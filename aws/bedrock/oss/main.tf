data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_opensearchserverless_vpc_endpoint" "oss_endpoint" {
  name               = "oss-endpoint"
  vpc_id             = var.vpc_id
  subnet_ids         = var.endpoint_subnet_ids
  security_group_ids =  [var.vpc_endpoint_security_group_id]
}


resource "aws_opensearchserverless_security_policy" "encryption" {
  name = "${var.oss_collection_name}-encryption"
  type = "encryption"
  policy = jsonencode({
    Rules = [{
      Resource     = ["collection/${var.oss_collection_name}"]
      ResourceType = "collection"
    }]
    AWSOwnedKey = true
  })
}

resource "aws_iam_role" "myrole" {
  name = "${var.oss_collection_name}-oss-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "opensearchservice.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}




resource "aws_opensearchserverless_access_policy" "data" {
  name = "${var.oss_collection_name}-data-policy"
  type = "data"

  policy = jsonencode([
    {
      Description = "KB access policy",

      Rules = [
        {
          ResourceType = "index"
          Resource = [
            "index/${var.oss_collection_name}/*"
          ]
          Permission = [
            "aoss:*"
          ]
        },
        {
          ResourceType = "collection"
          Resource = [
            "collection/${var.oss_collection_name}"
          ]
          Permission = [
            "aoss:*"
          ]
        }
      ],

      Principal = [
        var.knowledge_base_role_arn,
        data.aws_caller_identity.current.arn,
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/gitlab-runner-role"
      ]
    }
  ])
}


resource "aws_opensearchserverless_security_policy" "network_policy" {
  name        = "${var.oss_collection_name}-network-policy"
  type        = "network"
  description = "access for dashboard and collection endpoint"
  policy = jsonencode([{
    Rules = [{
      Resource     = ["collection/${var.oss_collection_name}"]
      ResourceType = "dashboard"
      },
      {
        Resource     = ["collection/${var.oss_collection_name}"]
        ResourceType = "collection"
    }]
    AllowFromPublic = true
  }])
}


resource "aws_opensearchserverless_collection" "collection" {
  name = var.oss_collection_name
  type = "VECTORSEARCH"

  depends_on = [
    aws_opensearchserverless_security_policy.encryption,
    aws_opensearchserverless_security_policy.network_policy,
    aws_opensearchserverless_access_policy.data,
    aws_opensearchserverless_vpc_endpoint.oss_endpoint
  ]
}



