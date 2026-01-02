resource "aws_iam_role" "ecs_execution_role" {
  description = "Allows ECS tasks to call AWS services on your behalf."
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  name = var.task_execution_role_name
}

resource "aws_iam_role" "ecs_task_role" {
  description = "Allows ECS tasks to call AWS services on your behalf."
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  name = var.task_role_name
}


resource "aws_iam_role_policy_attachment" "ecs_task_role_default_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.ecs_task_role.name
}


resource "aws_iam_role_policy_attachment" "ecs_task_role_s3_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.ecs_task_role.name
}


resource "aws_iam_role_policy_attachment" "ecs_task_role_secret_policy" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.ecs_task_role.name
}



# Custom policy for CloudWatch Logs access (without create permissions)
resource "aws_iam_role_policy" "ecs_execution_ecr_cloudwatch_policy" {
  name = "ecs-execution-ecr-logs-policy"
  role = aws_iam_role.ecs_execution_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams",
          "logs:DescribeLogGroups",
          "logs:CreateLogGroup"
        ]
        Resource = "*"
      }
    ]
  })
}


# Additional policy for kms access
resource "aws_iam_role_policy" "kms_access" {
  name = "kms_policy"
  role = aws_iam_role.ecs_task_role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kms:*",
        ]
        Resource = "*"
      }
    ]
  })
}
