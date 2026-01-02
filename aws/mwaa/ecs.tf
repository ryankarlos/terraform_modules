data "aws_iam_policy_document" "ecs_role_policy" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:PutLogEvents",
      "logs:GetLogEvents",
      "logs:GetLogRecord",
      "logs:GetLogGroupFields",
      "logs:GetQueryResults"
    ]
    resources = [
      "arn:aws:logs:${var.region}:${var.account_id}:log-group:airflow-${var.prefix}-${var.name}-*:*",
      "arn:aws:logs:*:*:log-group:*"
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      "arn:aws:secretsmanager:${var.region}:${var.account_id}:secret:airflow/*"
    ]
  }
  statement {
    effect  = "Deny"
    actions = ["s3:ListAllMyBuckets"]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*",
      "arn:aws:s3:::${var.bucket_name}-data",
      "arn:aws:s3:::${var.bucket_name}-data/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject*",
      "s3:GetBucket*",
      "s3:List*"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*",
      "arn:aws:s3:::${var.bucket_name}-data",
      "arn:aws:s3:::${var.bucket_name}-data/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject*"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}-data",
      "arn:aws:s3:::${var.bucket_name}-data/*",
    ]
  }
}

resource "aws_iam_role" "role_ecs" {
  name               = "${var.prefix}-ecs-role"
  path               = "/"
  tags               = var.tags
  assume_role_policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service":  [ 
              "ecs-tasks.amazonaws.com"
          ]
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
  EOF
}

resource "aws_iam_role_policy" "ecs_role_policy" {
  count  = var.add_ecs ? 1 : 0
  name   = "${var.prefix}-ecs-role-policy"
  role   = aws_iam_role.role_ecs.id
  policy = data.aws_iam_policy_document.ecs_role_policy.json
}
