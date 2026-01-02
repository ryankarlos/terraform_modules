
resource "aws_dax_subnet_group" "dax_subnets" {
  count = var.create_dax_cluster ? 1 : 0
  name       = var.dax_subnet_group_name
  subnet_ids = var.dax_subnet_ids 
}


resource "aws_dax_cluster" "dax_cluster" {
  count = var.create_dax_cluster ? 1 : 0
  cluster_name                     = var.dax_cluster_name
  iam_role_arn                     =  aws_iam_role.dax_role[count.index].arn
  node_type                        = var.dax_node_type
  replication_factor               = var.dax_replication_factor
  cluster_endpoint_encryption_type = "TLS"

  security_group_ids = var.dax_security_group_ids
  subnet_group_name  =  aws_dax_subnet_group.dax_subnets[count.index].name

  server_side_encryption {
    enabled = true
  }
}

# First, create an IAM role for RDS Enhanced Monitoring
resource "aws_iam_role" "dax_role" {
  count = var.create_dax_cluster ? 1 : 0
  name = "PrometheusDaxRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "dax.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}



resource "aws_iam_role_policy" "dax_ddb_access_policy" {
  # checkov:skip=CKV_AWS_355,CKV_AWS_290
  count = var.create_dax_cluster ? 1 : 0
  name = "dax_ddb_policy"
  role = aws_iam_role.dax_role[count.index].id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "dax:GetItem",
          "dax:BatchGetItem",
          "dax:Query",
          "dax:Scan",
          "dax:PutItem",
          "dax:UpdateItem",
          "dax:DeleteItem",
          "dax:BatchWriteItem",
          "dax:ConditionCheckItem"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:GetItem",
          "dynamodb:BatchGetItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DescribeTable",
          "dynamodb:ConditionCheckItem"
        ],
        "Resource" : "*"
      }
    ]
    }
  )
}
