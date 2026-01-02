
resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = var.workload_security_group_id

  cidr_ipv4   = var.ingress_cidr_range
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = var.workload_security_group_id

  cidr_ipv4   = var.ingress_cidr_range
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = var.workload_security_group_id

  cidr_ipv4   = var.ingress_cidr_range
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22
}

resource "aws_ec2_instance_connect_endpoint" "this" {
  subnet_id          = var.endpoint_subnet_ids[0]
  security_group_ids = [var.workload_security_group_id]
  tags = {
    Name = "ec2-instance-connect-vpce"
  }
}

resource "aws_vpc_endpoint" "datarobot" {
  count = var.create_datarobot_endpoint ? 1 : 0
  vpc_id              = var.vpc_id  
  service_name        = var.datarobot_endpoint_config.service_name
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  service_region            = var.datarobot_endpoint_config.region
  subnet_ids          = var.endpoint_subnet_ids
  security_group_ids  = var.endpoint_security_group_ids
  tags = {
    Name = "datarobot-vpce"
    Environment = var.env
  }
}


resource "aws_vpc_endpoint" "endpoints" {
  for_each = var.aws_service_endpoint_service_name

  vpc_id              = var.vpc_id
  service_name        = each.value
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = var.endpoint_subnet_ids
  security_group_ids  = var.endpoint_security_group_ids
  tags = {
    Name = each.key
    Environment = var.env
  }
}