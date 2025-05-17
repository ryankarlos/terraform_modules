

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "security_group_id" {
  description = "deault redflag security group id"
  type        = string
}


variable "tag" {
  description = "tag object"
   type = object({
    name = string
  })
}

variable "subnet_ids" {
  description = "List of endpoint subnets"
  type        = list(string)
}


variable "certificate_arn" {
  description = "ARN of ACM certificate for ALB HTTPS listener"
  type        = string
}


variable "alb_name" {
  description = "name of load balancer"
  type        = string
}

variable "cert_s3_key" {
  description = "cert s3 key for trust store"
  type        = string
  default = "cert.pem"
}


variable "target_group_port" {
  description = "target group port"
  type        = number
  default = 80
}


variable "target_group_protocol" {
  description = "target group protocol"
  type        = string
  default = "HTTP"
}


variable "health_check_protocol" {
  description = "target group protocol"
  type        = string
  default = "HTTP"
}



variable "health_check_enabled" {
  description = "whether to enable health check for lb target group"
  type        = bool
  default = true
}

variable "health_check_path" {
  description = "health check status check path"
  type        = string
  default = "/"
}