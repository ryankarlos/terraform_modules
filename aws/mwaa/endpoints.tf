# Airflow API Gateway Endpoint
resource "aws_vpc_endpoint" "api" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.airflow.api"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.endpoint_subnet_ids
  security_group_ids  = var.endpoint_sg
  private_dns_enabled = true
  tags                = var.tags
}

# Airflow env Gateway Endpoint
resource "aws_vpc_endpoint" "env" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.airflow.env"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.endpoint_subnet_ids
  security_group_ids  = var.endpoint_sg
  private_dns_enabled = true
  tags                = var.tags
}

# Airflow ops Gateway Endpoint
resource "aws_vpc_endpoint" "ops" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.airflow.ops"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.endpoint_subnet_ids
  security_group_ids  = var.endpoint_sg
  private_dns_enabled = true
  tags                = var.tags
}
