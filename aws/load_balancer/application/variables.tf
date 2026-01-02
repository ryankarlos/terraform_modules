
variable "trust_store_name"{
  description = "trust store name"
  type = string
  default = ""
}


variable "trust_store_bucket"{
  description = "trust store bucket"
  type = string
  default = ""
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "alb_name" {
  description = "name of load balancer"
  type        = string
}


variable "idle_timeout" {
  description = "timeout value"
  type        = number
  default = 90
}



variable "enable_deletion_protection" {
  description = "deletion protection"
  type        = bool
  default = false
}



variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}


variable "subnet_ids" {
  description = "List of endpoint subnets"
  type        = list(string)
}



variable "certificate_arn" {
  description = "ARN of ACM certificate for ALB HTTPS listener"
  type        = string
}

variable "target_group_arn" {
  description = "ARN of the load balancer target group"
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


variable "cert_s3_key" {
  description = "cert s3 key for trust store"
  type        = string
  default = "cert.pem"
}


variable "enable_mutual_authentication" {
  description = "Enable mutual TLS authentication"
  type        = bool
  default     = true
}

variable "enable_cognito_authentication" {
  description = "Enable Cognito authentication"
  type        = bool
  default     = false
}


variable "user_pool_arn" {
  description = "cognito user pool arn"
  type        = string
  default     = ""
}


variable "user_pool_client_id" {
  description = "cognito user pool client id"
  type        = string
  default     = ""
}


variable "user_pool_domain" {
  description = "cognito user pool domain"
  type        = string
  default     = ""
}


variable "enable_http_listener" {
  description = "whether to disable http listener"
  type        = string
  default     = true
}

variable "ssl_policy" {
  description = "lb security policy"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
}

variable "auth_cookie_timeout" {
  description = "cookie timeout alb"
  type        = number
  default     = 45000
}