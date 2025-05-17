variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

# Variables for GCP credentials
variable "hmac_access_id" {
  description = "GCP HMAC access key for authentication"
  type        = string
  sensitive   = true
}

variable "hmac_secret" {
  description = "GCP HMAC secret key for authentication"
  type        = string
  sensitive   = true
}

variable "s3_dest_bucket" {
  description = "s3 destination bucket for transferring data from GCP"
  type        = string
}

variable "s3_source_bucket" {
  description = "s3 source bucket for transferring data to GCP"
  type        = string
}

variable "gcp_source_bucket" {
  description = "GCP source bucket for transferring data to AWS"
  type        = string
}

variable "gcp_dest_bucket" {
  description = "GCP dest bucket for transferring data from AWS"
  type        = string
}

variable "datasync_ami_id" {
  description = "ami-id-for-datasync"
  type        = string
}


variable "datasync_agent_size" {
  description = "size of datasync_agent"
  type        = string
}

variable "schedule_expression" {
  description = "schedule expression"
  type        = string
}


variable "tags" {
  description = "tags"
  type        = map(string)
}


variable "datasync_task_options" {
  type = object({
    verify_mode            = string
    preserve_deleted_files = string
    task_queueing          = string
    log_level              = string
    transfer_mode          = string
  })
  default = {
    verify_mode            = "ONLY_FILES_TRANSFERRED"
    preserve_deleted_files = "REMOVE"
    task_queueing          = "ENABLED"
    log_level              = "BASIC"
    transfer_mode          = "CHANGED"
  }
}


variable "datasync_role_name" {
  description = "role name for datasync s3"
  type        = string
}
