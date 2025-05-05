variable "bucket_name" {
  type        = string
  description = "bucket name"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "s3_encryption" {
  type        = string
  description = "encryption to use e.g SSE-S3, KMS"
  default     = "AES256"
  validation {
    condition     = can(regex("^(AES256||aws:kms:ddsse||aws:kms)$", var.s3_encryption))
    error_message = "The encryption must be either AES256, aws:kms, aws:kms:dsse"
  }
}


variable "force_destroy" {
  description = "Force destroy the S3 bucket and its contents when destroying the Terraform resource"
  type        = bool
  default     = false
}

variable "enable_versioning" {
  description = "Enable versioning for s3 bucket"
  type        = bool
  default     = false
}

variable "enable_s3_encryption" {
  description = "Enable or disable server-side encryption for the S3 bucket."
  type        = bool
  default     = false
}

variable "enable_kms" {
  description = "Enable versioning for s3 bucket"
  type        = bool
  default     = false
}

variable "kms_key" {
  description = "The arn of the KMS key to be used to encrypt the contents of the bucket"
  type        = string
  default     = null
}

variable "expiration_days" {
  description = "The number of days before an object is deleted"
  type        = number
  default     = 10
}

variable "enable_expiration" {
  description = "The number of days before an object is deleted"
  type        = bool
  default     = false
}

variable "expire_prefix" {
  description = "Any filter for the expiration_days to be applied"
  type        = string
  default     = ""
}

variable "admin_role_arn" {
  description = "ARN of the admin/root role."
  type        = string
  default     = "*"
}

variable "read_write_role_arn" {
  description = "ARN of the read/write role."
  type        = string
  default     = "*"
}

variable "read_only_role_arn" {
  description = "ARN of the read-only role."
  type        = string
  default     = "*"
}

variable "delete_role_arn" {
  description = "ARN of the read-only role."
  type        = string
  default     = "arn:aws:iam::345594580133:instance-profile/gitlab-runner-instance-profile"
}

variable "cidr_range" {
  description = "CIDR range for restricting access."
  type        = list(string)
  default     = ["10.0.0.0/8"]
}

variable "require_https" {
  description = "Whether to require HTTPS access to the S3 bucket."
  type        = bool
  default     = true # Default to requiring HTTPS
}
