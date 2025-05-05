data "aws_region" "current" {}

resource "aws_vpc_endpoint" "bedrock_runtime" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.bedrock-runtime"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.endpoint_subnet_ids
  private_dns_enabled = true
  
  security_group_ids = [var.vpc_endpoint_security_group_id]

  tags = {
    Name = "bedrock_runtime_endpoint"
  }
}


