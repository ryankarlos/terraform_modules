data "aws_vpc_endpoint" "existing" {
  for_each = toset(var.existing_bedrock_vpc_endpoint_id)
  id       = each.value
}
# Existing endpoint (used when not creating a new one)
data "aws_vpc_endpoint" "existing_bedrock_runtime" {
  count = var.create_bedrock_vpc_endpoint ? 0 : 1
  id    = var.existing_bedrock_vpc_endpoint_id[0]
}
