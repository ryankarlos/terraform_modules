variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "dags_path" {
  description = "The path to the dags folder in the bucket"
  type        = string
  default     = "dags/"
}

variable "mwaa_version" {
  description = "The version of the MWAA"
  type        = string
  default     = "2.9.2"
}

variable "env_class" {
  description = "The env class of MWAA"
  type        = string
  default     = "mw1.small"
}

variable "enable_kms" {
  description = "Enable/Disable KMS"
  type        = bool
  default     = true
}

variable "prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "dsai-mwaa"
}

variable "name" {
  description = "MWAA environment name"
  type        = string
  default     = "pub"
}

variable "account_id" {
  description = "Account ID"
  type        = string
  default     = "345594580133"
}

variable "is_private" {
  description = "Controls the visibility of the airflow web ui"
  type        = bool
  default     = true
}

variable "tags" {
  type = object({
    name = string
  })
  default = {
    name = "dsai-mwaa"
  }
}

variable "allowed_cidr_blocks" {
  description = "List of allowed CIDR blocks for Web UI access (private IP ranges only)"
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
  default     = "dsai-airflow-dags"
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
  default     = "vpc-06048e6e821493c73"
}

variable "add_ecs" {
  description = "Should add an ECS"
  type        = bool
  default     = true
}

variable "subnet_ids" {
  description = "Ids of the existing private subnets"
  type        = list(string)
}

variable "endpoint_subnet_ids" {
  description = "Ids of the existing private subnets meant for vpc endpoint"
  type        = list(string)
}

variable "force_destroy_bucket" {
  description = "Force destroy bucket"
  type        = bool
  default     = false
}

variable "endpoint_sg" {
  description = "Endpoint security group"
  type        = list(string)
}

variable "has_requirements_file" {
  description = "Flag to set adding a requirements file to the bucket"
  type        = bool
}

variable "requirements_file" {
  description = "The path to the requirements file"
  type        = string
}
