data "aws_region" "current" {}

# Transform to get private IPs
locals {
  all_endpoint_enis = var.create_vpc_endpoint ? flatten([
    for ep in aws_vpc_endpoint.api_gateway : ep.network_interface_ids
  ]) : flatten([
    for ep in data.aws_vpc_endpoint.existing : ep.network_interface_ids
  ])
  endpoint_ips = flatten([
    for eni in data.aws_network_interface.endpoint_eni : eni.private_ips
  ])
}

# in future make this less permissive 
data "aws_iam_policy_document" "policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["execute-api:Invoke"]
    resources = ["*"]
  }
}

data "aws_vpc_endpoint" "existing" {
  for_each = toset(var.external_vpc_endpoint_ids)
  id       = each.value
}

data "aws_network_interface" "endpoint_eni" {
  # count = length(var.endpoint_subnet_ids)
  count = length(local.all_endpoint_enis)
  id    = local.all_endpoint_enis[count.index]
}



