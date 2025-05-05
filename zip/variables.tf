variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}


variable "subnet_ids" {
  description = "List of endpoint subnets"
  type        = list(string)
}


variable "security_group_id" {
  description = "lambda security group id"
  type        = string
}

variable "lambda_memory" {
  description = "lambda memory"
  type        = number
  default = 2048
}


variable "lambda_timeout" {
  description = "timeout for lambda function"
  type        = number
}

variable "filename" {
  description = "output path for lambda zip"
  type        = string
}


variable "enable_layers" {
  description = "Boolean flag to enable/disable Lambda layers"
  type        = bool
  default     = false
}

variable "lambda_layers" {
  description = "List of Lambda layer ARNs to attach"
  type        = list(string)
  default     = []
}
variable "function_name" {
  description = "lambda function name"
  type        = string
}

variable "lambda_role" {
  description = "lambda role name"
  type        = string
}


variable "storage" {
  description = "lambda role name"
  type        = number
  default = 512
}


variable "environment_variables" {
  description = "lambda environment variables"
  type        = map(string)
  default = {}
}


variable "source_code_hash" {
  description = "source code hash"
  type        = string
  default = ""
}

