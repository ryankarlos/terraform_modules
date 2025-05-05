variable "enable_key_rotation" {
  description = "Enable or disable key rotation for the KMS key"
  type        = bool
  default     = true
}

variable "key_name" {
  description = "The name used for the key alias"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "deletion_window" {
  description = "The number of days before a key is deleted for rotation"
  type        = number
}
