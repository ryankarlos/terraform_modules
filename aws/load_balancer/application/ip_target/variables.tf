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



variable "target_group_name" {
  description = "target group name"
  type        = string
  default = "ip-target"
}


variable "minimum_healthy_targets_count" {
  description = "The minimum number of targets that must be healthy"
  type        = number
  default = 1
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

variable "stickiness_enabled" {
  description = "Enable stickiness for the target group"
  type        = bool
  default     = false
}

variable "stickiness_type" {
  description = "Type of stickiness (only 'lb_cookie' supported for ALB)"
  type        = string
  default     = "lb_cookie"
}

variable "stickiness_cookie_duration" {
  description = "Duration (in seconds) for the stickiness cookie"
  type        = number
  default     = 86400
}

variable "deregistration_delay" {
  description = "Time in seconds for deregistration delay (connection draining) on the target group"
  type        = number
  default     = 300
}

variable "ssl_policy" {
  description = "lb security policy"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
}

variable "auth_cookie_timeout" {
  description = "cookie timeout alb"
  type        = number
  default     = 3600
}