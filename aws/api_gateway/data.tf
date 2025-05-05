data "aws_region" "current" {}


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


data "aws_network_interface" "endpoint_eni" {
  count = length(var.endpoint_subnet_ids)
  id = tolist(aws_vpc_endpoint.api_gateway.network_interface_ids)[count.index]
  depends_on = [aws_vpc_endpoint.api_gateway]
}



# Transform to get private IPs
locals {
  endpoint_ips = flatten([
    for eni in data.aws_network_interface.endpoint_eni : eni.private_ips
  ])
}