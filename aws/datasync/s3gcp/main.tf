locals {
  datasync_subnet_arn = [for subnet_id in var.endpoint_subnet_ids: "arn:aws:ec2:${var.aws_region}:${data.aws_caller_identity.current.account_id}:subnet/${subnet_id}"][0]
}



# S3 location for DataSync
resource "aws_datasync_location_s3" "s3_source" {
  s3_bucket_arn = var.source_s3_bucket_arn
  subdirectory  = var.s3_source_object_prefix

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync_s3_access_role.arn
  }
}

resource "aws_datasync_location_s3" "s3_dest" {
  s3_bucket_arn = var.destination_s3_bucket_arn
  subdirectory  = var.s3_dest_object_prefix

  # Credentials for GCP access

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync_s3_access_role.arn
  }
}

# Create HTTPS endpoints for DataSync agent
resource "aws_datasync_location_object_storage" "gcp_dest_bucket" {
  server_hostname = "storage.googleapis.com"
  bucket_name     = var.gcp_dest_bucket
  subdirectory    = var.gcp_dest_object_prefix

  # Credentials for GCP access
  secret_key = var.hmac_secret
  access_key = var.hmac_access_id

  server_port     = 443
  server_protocol = "HTTPS"

  agent_arns = [aws_datasync_agent.gcp_agent.arn]
}


resource "aws_datasync_location_object_storage" "gcp_source_bucket" {
  server_hostname = "storage.googleapis.com"
  bucket_name     = var.gcp_source_bucket
  subdirectory    = var.gcp_source_object_prefix

  # Credentials for GCP access
  secret_key = var.hmac_secret
  access_key = var.hmac_access_id

  server_port     = 443
  server_protocol = "HTTPS"

  agent_arns = [aws_datasync_agent.gcp_agent.arn]
}

# Task for S3 to GCP transfer
resource "aws_datasync_task" "s3_to_gcp" {
  source_location_arn      = aws_datasync_location_s3.s3_source.arn
  destination_location_arn = aws_datasync_location_object_storage.gcp_dest_bucket.arn
  name                     = "S3toGCP"
  cloudwatch_log_group_arn = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/datasync:*"

  options {
    verify_mode            = var.datasync_task_options.verify_mode
    preserve_deleted_files = var.datasync_task_options.preserve_deleted_files
    task_queueing          = var.datasync_task_options.task_queueing
    log_level              = var.datasync_task_options.log_level
    transfer_mode          = var.datasync_task_options.transfer_mode
    posix_permissions      = "NONE"
    uid                    = "NONE"
    gid                    = "NONE"
  }

  task_report_config {
    s3_destination {
      s3_bucket_arn          = var.report_s3_bucket_arn
      bucket_access_role_arn = aws_iam_role.datasync_s3_access_role.arn
      subdirectory           = "s3-to-gcp/"
    }
    report_level         = "SUCCESSES_AND_ERRORS"
    output_type          = "STANDARD"
    s3_object_versioning = "NONE"
    report_overrides {}
  }


  # Schedule only if schedule_expression is provided
  dynamic "schedule" {
    for_each = var.use_datasync_schedule ? [1] : []
    content {
      schedule_expression = var.schedule_expression
    }
  }
}

# Task for GCP to S3 transfer
resource "aws_datasync_task" "gcp_to_s3" {
  source_location_arn      = aws_datasync_location_object_storage.gcp_source_bucket.arn
  destination_location_arn = aws_datasync_location_s3.s3_dest.arn
  name                     = "GCPtoS3"
  cloudwatch_log_group_arn = "arn:aws:logs:${var.aws_region}:${data.aws_caller_identity.current.account_id}:log-group:/aws/datasync:*"

  options {
    verify_mode            = var.datasync_task_options.verify_mode
    preserve_deleted_files = var.datasync_task_options.preserve_deleted_files
    task_queueing          = var.datasync_task_options.task_queueing
    log_level              = var.datasync_task_options.log_level
    transfer_mode          = var.datasync_task_options.transfer_mode
    posix_permissions      = "NONE" # throws exceptions if these are not set to None ?
    uid                    = "NONE"
    gid                    = "NONE"
  }
  task_report_config {
    s3_destination {
      s3_bucket_arn          = var.report_s3_bucket_arn
      bucket_access_role_arn = aws_iam_role.datasync_s3_access_role.arn
      subdirectory           = "gcp-to-s3/"
    }
    report_level         = "SUCCESSES_AND_ERRORS"
    output_type          = "STANDARD"
    s3_object_versioning = "NONE"
    report_overrides {}
  }

  # Schedule only if schedule_expression is provided
  dynamic "schedule" {
    for_each = var.use_datasync_schedule ? [1] : []
    content {
      schedule_expression = var.schedule_expression
    }
  }

  tags = var.tags
}


resource "aws_iam_role" "datasync_s3_access_role" {
  name = var.datasync_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "datasync.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "datasync_s3_policy_attachment" {
  role       = aws_iam_role.datasync_s3_access_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


# IAM role for EC2 instance to activate DataSync agent
resource "aws_iam_role" "datasync_agent_activation_role" {
  name = var.datasync_ec2_profile

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Policy to allow EC2 to create and activate DataSync agent
resource "aws_iam_policy" "datasync_activation_policy" {
  name        = "datasync-activation-policy"
  description = "Policy to allow EC2 to create and activate DataSync agent"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "datasync:CreateAgent",
          "datasync:CreateAgentActivationKey",
          "datasync:ActivateAgent"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "datasync_activation_policy_attachment" {
  role       = aws_iam_role.datasync_agent_activation_role.name
  policy_arn = aws_iam_policy.datasync_activation_policy.arn
}

resource "aws_iam_instance_profile" "datasync_instance_profile" {
  name = var.datasync_ec2_profile
  role = aws_iam_role.datasync_agent_activation_role.name
}

resource "aws_instance" "datasync_agent" {
  #checkov:skip=CKV2_AWS_41: IAM role automatically attached by datasync service
  #checkov:skip=CKV_AWS_79:
  #checkov:skip=CKV_AWS_126: detailed monitoring not required here
  ami                    = var.datasync_ami_id
  instance_type          = var.datasync_agent_size
  subnet_id              = var.workload_subnet_ids[0]
  ebs_optimized          = true
  vpc_security_group_ids = [aws_security_group.datasync_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.datasync_instance_profile.name

  root_block_device {
    encrypted = true
  }


  tags = { Name = "datasync-agent" }
}

# DataSync agent activation
resource "aws_datasync_agent" "gcp_agent" {
  name                  = "S3GCPAgent"
  security_group_arns   = [var.endpoint_security_group_arn]
  vpc_endpoint_id       = aws_vpc_endpoint.datasync_endpoint.id
  ip_address            = aws_instance.datasync_agent.private_ip
  subnet_arns           = [local.datasync_subnet_arn]
  private_link_endpoint = data.aws_network_interface.datasync_interface.private_ip
  depends_on            = [aws_instance.datasync_agent, aws_vpc_endpoint.datasync_endpoint]
}

# VPC endpoint for DataSync
resource "aws_vpc_endpoint" "datasync_endpoint" {
  vpc_id              = data.aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.datasync"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.endpoint_subnet_ids
  security_group_ids  = [var.endpoint_security_group_id]
  private_dns_enabled = true
  tags = {
    Name = "vpce-datasync"
  }

}


# Security group for HTTP access
resource "aws_security_group" "datasync_security_group" {
  #checkov:skip= CKV_AWS_382:
  #checkov:skip= CKV_AWS_23:
  name        = "http-access"
  description = "Allow HTTP inbound and all outbound traffic"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "http-access"
  }
}