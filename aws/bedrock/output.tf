locals {
  all_endpoint_enis = var.create_bedrock_vpc_endpoint ? flatten([
    for ep in aws_vpc_endpoint.bedrock_runtime : ep.network_interface_ids
  ]) : flatten([
    for ep in data.aws_vpc_endpoint.existing : ep.network_interface_ids
  ])
  endpoint_ids = var.create_bedrock_vpc_endpoint ? aws_vpc_endpoint.bedrock_runtime[0].id : data.aws_vpc_endpoint.existing_bedrock_runtime[0].id
}

output  "vpc_endpoint_id" {
  description = "bedrock endpoint id"
  value = local.endpoint_ids
}

output  "vpc_endpoint_network_interface_ids" {
  description = "bedrock endpoint network interface ids"
  value = local.all_endpoint_enis
}

