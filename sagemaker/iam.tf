
# IAM Role for SageMaker execution
resource "aws_iam_role" "admin" {
  name = "sagemaker-role-admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "secret_manager_read_write" {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "s3_full_access" {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# Attach necessary policies to the IAM role
resource "aws_iam_role_policy_attachment" "bedrock_full_access" {
  role       = aws_iam_role.admin.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonBedrockFullAccess"
}



# Additional policy for VPC access
resource "aws_iam_role_policy" "vpc_access" {
  name = "sagemaker-vpc-access"
  role = aws_iam_role.admin.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:CreateNetworkInterfacePermission",
          "ec2:DeleteNetworkInterface",
          "ec2:DeleteNetworkInterfacePermission",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DescribeVpcs",
          "ec2:DescribeDhcpOptions",
          "ec2:DescribeSubnets",
          "ec2:DescribeSecurityGroups"
        ]
        Resource = "*"
      }
    ]
  })
}



# Additional policy for VPC access
resource "aws_iam_role_policy" "deny_delete" {
  name = "mlflow_policy"
  role = aws_iam_role.admin.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {            
            "Effect": "Allow",            
            "Action": "sagemaker-mlflow:*",            
            "Resource": "*"        
      }, 
      {
        Effect = "Deny"
        Action = [
          "sagemaker:DeleteMlflowTrackingServer",
        ]
        Resource = "*"
      }
    ]
  })
}



# Additional policy for kms access
resource "aws_iam_role_policy" "kms_access" {
  name = "kms_policy"
  role = aws_iam_role.admin.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      }
    ]
  })
}
