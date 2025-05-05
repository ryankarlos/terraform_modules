

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
}