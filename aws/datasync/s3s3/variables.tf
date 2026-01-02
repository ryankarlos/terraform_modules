variable "source_bucket_arn" {
  description = "ARN of the source S3 bucket for DataSync"
  type        = string
}

variable "s3_source_object_prefix" {
  description = "S3 prefix (subdirectory) inside the source bucket"
  type        = string
  default     = "" # optional, empty means root
}

variable "destination_s3_bucket_arn" {
  description = "ARN of the destination S3 bucket for DataSync"
  type        = string
}

variable "s3_dest_object_prefix" {
  description = "S3 prefix (subdirectory) inside the destination bucket"
  type        = string
  default     = ""
}

variable "datasync_task_name" {
  description = "Name of the DataSync task"
  type        = string
  default     = "s3tos3"
}

variable "tags" {
  description = "Tags to apply to DataSync resources"
  type        = map(string)
  default     = {}
}

variable "datasync_role_arn" {
  description = "IAM Role ARN that DataSync will use to access S3"
  type        = string
}

