# Provider configuration
provider "aws" {
  region = var.aws_region
}

locals {
  az_subnet_ids = {
    workload = flatten([
      for az, subnets in data.aws_subnets.workload_subnet : subnets.ids
    ])
    endpoint = flatten([
      for az, subnets in data.aws_subnets.endpoint_subnet : subnets.ids
    ])
  }
}

# AWS DataSync resources for S3 to GCP and GCP to S3 data transfer


module "s3_gcp_inbound" {
  source      = "github.com/ryankarlos/terraform_modules.git//aws/s3"
  bucket_name = var.s3_source_bucket
  tags        = var.tags
}

module "s3_gcp_outbound" {
  source      = "github.com/ryankarlos/terraform_modules.git//aws/s3"
  bucket_name = var.s3_dest_bucket
  tags        = var.tags
}



# IAM role for DataSync
resource "aws_iam_role" "datasync_role" {
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



resource "aws_iam_role_policy_attachment" "datasync_policy_attachment" {
  role       = aws_iam_role.datasync_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


# S3 location for DataSync
resource "aws_datasync_location_s3" "s3_source" {
  s3_bucket_arn = module.s3_gcp_inbound.s3_bucket_arn
  subdirectory  = "/source"

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync_role.arn
  }
}

resource "aws_datasync_location_s3" "s3_dest" {
  s3_bucket_arn = module.s3_gcp_inbound.s3_bucket_arn
  subdirectory  = "/sink"

  s3_config {
    bucket_access_role_arn = aws_iam_role.datasync_role.arn
  }
}

# Create HTTPS endpoints for DataSync agent
resource "aws_datasync_location_object_storage" "gcp_dest_bucket" {
  server_hostname = "storage.googleapis.com"
  bucket_name     = var.gcp_dest_bucket

  # Credentials for GCP access
  secret_key = var.hmac_secret
  access_key = var.hmac_access_id

  server_port     = 443
  server_protocol = "HTTPS"

  agent_arns = [aws_datasync_agent.gcp_agent.arn]
}


resource "aws_datasync_location_object_storage" "gcp_source_bucket" {
  server_hostname = "storage.googleapis.com"
  bucket_name     = var.gcp_dest_bucket

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
  name                     = "s3-to-cloudstorage"

  options {
    verify_mode            = var.datasync_task_options.verify_mode
    preserve_deleted_files = var.datasync_task_options.preserve_deleted_files
    task_queueing          = var.datasync_task_options.task_queueing
    log_level              = var.datasync_task_options.log_level
    transfer_mode          = var.datasync_task_options.transfer_mode
  }

  schedule {
    schedule_expression = var.schedule_expression
  }
}

# Task for GCP to S3 transfer
resource "aws_datasync_task" "gcp_to_s3" {
  source_location_arn      = aws_datasync_location_object_storage.gcp_source_bucket.arn
  destination_location_arn = aws_datasync_location_s3.s3_dest.arn
  name                     = "cloudstorage-to-s3"

  options {
    verify_mode            = var.datasync_task_options.verify_mode
    preserve_deleted_files = var.datasync_task_options.preserve_deleted_files
    task_queueing          = var.datasync_task_options.task_queueing
    log_level              = var.datasync_task_options.log_level
    transfer_mode          = var.datasync_task_options.transfer_mode
  }

  schedule {
    schedule_expression = var.schedule_expression
  }

  tags = var.tags
}


resource "aws_instance" "datasync_agent" {
  #checkov:skip=CKV2_AWS_41: IAM role automatically attached by datasync service
  #checkov:skip=CKV_AWS_79:
  #checkov:skip=CKV_AWS_126: detailed monitoring not required here
  ami                    = var.datasync_ami_id
  instance_type          = var.datasync_agent_size
  subnet_id              = local.az_subnet_ids.workload[0]
  ebs_optimized          = true
  vpc_security_group_ids = [data.aws_security_group.workload_security_group.id]
  root_block_device {
    encrypted = true
  }

  tags = var.tags
}


# DataSync agent activation
resource "aws_datasync_agent" "gcp_agent" {
  name                = "gcp-datasync-agent"
  security_group_arns = [data.aws_security_group.workload_security_group.arn]
  vpc_endpoint_id     = aws_vpc_endpoint.datasync_endpoint.id

  depends_on = [aws_instance.datasync_agent]
}

# VPC endpoint for DataSync
resource "aws_vpc_endpoint" "datasync_endpoint" {
  vpc_id              = data.aws_vpc.main.id
  service_name        = "com.amazonaws.${var.aws_region}.datasync"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = local.az_subnet_ids.endpoint
  security_group_ids  = [data.aws_security_group.endpoint_security_group.id]
  private_dns_enabled = true
  tags                = var.tags
}
