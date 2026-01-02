

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
  default     = null
}

variable "force_new_deployment" {
  description = "Flag to set force new deployment"
  type        = bool
  default     = false
}

variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = null
}


variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "runtime_platform" {
  description = "runtime_platform mapping details"
  type        = map(any)
  default = {
    "cpu_architecture"        = "X86_64"
    "operating_system_family" = "LINUX"
  }
}


variable "container_port" {
  description = "Container port"
  type        = number
  default     = 80
}


variable "launch_type" {
  description = "Launch type for the ECS service (FARGATE or EC2)"
  type        = string
}

variable "container_definitions" {
  description = "Container definitions in JSON format"
  type        = string
  default     = null
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "enable_load_balancer" {
  description = "Whether to enable load balancer"
  type        = bool
  default     = false
}


variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
  default     = null
}


variable "task_cpu" {
  description = "Task CPU units"
  type        = number
  default     = 1024
}

variable "task_memory" {
  description = "Task memory (MiB)"
  type        = number
  default     = 4096
}

variable "ephemeral_storage" {
  type    = number
  default = 21
}


variable "max_capacity" {
  description = "Maximum number of tasks"
  type        = number
  default     = 4
}

variable "min_capacity" {
  description = "Minimum number of tasks"
  type        = number
  default     = 1
}

variable "scaling_type" {
  description = "whether to use target tracking  (e.g. cpu, memory) or step scaling"
  type        = string
  default     = "step"
  validation {
    condition     = contains(["step", "cpu", "memory"], var.scaling_type)
    error_message = "The scaling type must be either step or cpu or memory."
  }
}



variable "step_scaling_config" {
  description = "step scaling config"
  type        = map(number)
  default = {
    cooldown                    = 60
    metric_interval_upper_bound = 0
    scaling_adjustment          = -1
  }
}


variable "cpu_target_value" {
  description = "Target CPU utilization %"
  type        = number
  default     = 70
}

variable "memory_target_value" {
  description = "Target memory utilization %"
  type        = number
  default     = 70
}

variable "scale_in_cooldown" {
  description = "Scale-in cooldown period"
  type        = number
  default     = 300
}

variable "scale_out_cooldown" {
  description = "Scale-out cooldown period"
  type        = number
  default     = 300
}


variable "platform_version" {
  description = "Platform version for Fargate"
  type        = string
  default     = "LATEST"
}

variable "deployment_controller_type" {
  description = "Type of deployment controller"
  type        = string
  default     = "ECS"
}

variable "enable_circuit_breaker" {
  description = "Enable deployment circuit breaker"
  type        = bool
  default     = true
}

variable "enable_circuit_breaker_rollback" {
  description = "Enable deployment circuit breaker rollback"
  type        = bool
  default     = true
}


variable "listener_arn" {
  description = "Listener arn"
  type        = string
}


variable "listener_rule_path" {
  description = "path for redirecting to target group in listener rule"
  type        = string
  default = "/*"
}

variable "host_header_rule" {
  description = "host header rule"
  type        = string
  default = "*"
}

variable "cluster_name" {
  description = "cluster name"
  type        = string
}

variable "cluster_arn" {
  description = "cluster arn to associate service to"
  type        = string
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
}

variable "minimum_healthy_targets_count" {
  description = "The minimum number of targets that must be healthy"
  type        = number
  default = 1
}


variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}


variable "task_execution_role_name" {
  description = "Task execution role name"
  type        = string
}


variable "task_role_name" {
  description = "Task role name"
  type        = string
}

variable "listener_rule_priorty" {
  description = "listener rule priority"
  type        = number
  default = 100
}



# Variables for Cognito authentication
variable "enable_cognito_authentication" {
  description = "Enable Cognito authentication for the load balancer rule"
  type        = bool
  default     = false
}

variable "user_pool_arn" {
  description = "ARN of the Cognito User Pool (required when enable_cognito_auth is true)"
  type        = string
  default     = ""
}

variable "user_pool_client_id" {
  description = "Client ID of the Cognito User Pool (required when enable_cognito_auth is true)"
  type        = string
  default     = ""
}

variable "user_pool_domain" {
  description = "Domain of the Cognito User Pool (required when enable_cognito_auth is true)"
  type        = string
  default     = ""
}

variable "auth_cookie_timeout" {
  description = "cookie timeout alb"
  type        = number
  default     = 45000
}