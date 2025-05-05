output  "vpc_endpoint_id" {
  description = "bedrock endpoint id"
  value = aws_vpc_endpoint.bedrock_runtime.id
}

output  "vpc_endpoint_network_interface_ids" {
  description = "bedrock endpoint network interface ids"
  value = aws_vpc_endpoint.bedrock_runtime.network_interface_ids
}