
variable "env" {
  description = "account environment e.g. dev or prod"
  type        = string
}



variable "endpoint_subnet_ids" {
  description = "List of endpoint subnets"
  type        = list(string)
}

variable "vpc_id" {
  description = "vpc id"
  type        = string
}


variable "endpoint_security_group_ids" {
  description = "endpoint security group id"
  type        = list(string)
}

variable "workload_security_group_id" {
  description = "workload security group id"
  type        = string
}

variable "ingress_cidr_range" {
  description = "cidr range for security group ingress rule. Defaults to Entain cidr range"
  type        = string
  default = "10.0.0.0/8"
}


variable "create_datarobot_endpoint" {
  description = "whether to create dr endpoint"
  type        = bool
  default = false
}

variable "create_snowflake_endpoint" {
  description = "whether to create snowflake endpoint"
  type        = bool
  default = false
}

variable "aws_service_endpoint_service_name" {
  description = "list of aws service endpoint names"
  type        = map(string)
  default = {}
}


variable "datarobot_endpoint_config" {
  description = "datarobot endpoint service name and region"
  type        = map(string)
  default = {}
}