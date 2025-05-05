variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

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

variable "enable_container_insights" {
  description = "Whether to enable CloudWatch Container Insights for the cluster"
  type        = bool
  default     = true
}

variable "execute_command_logging" {
  description = "The log setting to use for redirecting logs for execute command results. Valid values: NONE, DEFAULT, OVERRIDE"
  type        = string
  default     = "DEFAULT"
}

variable "create_cloudwatch_log_group" {
  description = "Whether to create a CloudWatch log group for the ECS cluster"
  type        = bool
  default     = true
}

variable "cloudwatch_log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 30
}

variable "cloudwatch_log_kms_key_id" {
  description = "KMS key ARN to use for encrypting CloudWatch logs"
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


variable "target_group_arn" {
  description = "alb target group arn"
  type        = string
  default     = null
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

variable "task_execution_role_name" {
  description = "Task execution role name"
  type        = string
  default     = "TaskExecutionRole"
}


variable "task_role_name" {
  description = "Task role name"
  type        = string
  default     = "TaskRole"
}

variable "add_service" {
  description = "Flag to add an ECS service"
  type        = bool
  default     = true
}
