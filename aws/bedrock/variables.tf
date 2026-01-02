variable "create_bedrock_vpc_endpoint" {
  type    = bool
  default = true
}


variable "existing_bedrock_vpc_endpoint_id" {
  type = list(string)
  default = [] 
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}


variable "vpc_endpoint_security_group_id" {
  description = "vpc endpoint security group id"
  type        = string
}

variable "endpoint_subnet_ids" {
  description = "vpc endpoint subnet ids"
  type        = list(string)
}



variable "tag" {
  description = "tag object"
   type = object({
    name = string
  })
  default = {
    name     = "project"
  }
}


variable "security_group_id" {
  description = "Name of the security group id"
  type        = string
}

# variable "main_guardrail_name" {
#   description = "Name of the bedrock guardrail"
#   type        = string
# }
