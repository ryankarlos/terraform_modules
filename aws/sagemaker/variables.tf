
variable "domain_name" {
  description = "Name of the SageMaker domain"
  type        = string
  default     = "dsai-domain"
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "workload_subnet_ids" {
  description = "List of workload subnet IDs"
  type        = list(string)
}

variable "endpoint_subnet_ids" {
  description = "List of endpoint subnet IDs"
  type        = list(string)
}

variable "workload_security_group_ids" {
  description = "List of workload security group ids"
  type        = list(string)
}


variable "endpoint_security_group_ids" {
  description = "List of endpoint security group ids"
  type        = list(string)
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "idle_shutdown" {
  description = "idle shutdown in mins for jupyter and code editor"
  type        = number
  default     = 60
}



variable "users_sso" {
  description = "map of user profile names and valid username of user in iam identity center"
  type = map(string)
  validation {
    condition     = alltrue([ for profilename, _ in var.users_sso: can(regex("^[a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}", profilename))])
    error_message = "Username must start with alphanumeric character and can contain hyphens between alphanumeric characters. Maximum length is 63 characters. Format: ^[a-zA-Z0-9](-*[a-zA-Z0-9]){0,62}"
  }
  default = {}
}


variable "users_iam" {
  description = "List of users iam to create for sagemaker domain"
  type        = list(string)
  default = []
}



variable "storage_size" {
  description = "private space storage size ebs"
  type = object(
    {
      default = number
      max  = number
    }
  )
  default = {
    default = 20,
    max = 40
  }
}

variable "hidden_instance_types" {
  description = "List of instance types to hide from users in sagemaker studio ui"
  type        = list(string)
}


variable "auth_mode" {
  description = "sagemaker domain user auth mode"
  type        = string
  default = "SSO"
}
