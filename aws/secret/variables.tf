variable "secret_name" {
  description = "The name of the AWS Secrets Manager secret."
  type        = string
}

variable "secret_file_path" {
  description = "The path to the file containing the secret content."
  type        = string
  default = ""
}

variable "secret_type" {
  description = "The type of the secret (e.g., 'plaintext', 'binary')."
  type        = string
  default     = "plaintext"
}

variable "secret_value" {
  description = "secret value if secret type is not plaintext (file type)"
  type        = string
  default     = ""
}

variable "kms_key_id" {
  description = "The KMS key ID to use for encrypting the secret."
  type        = string
  default     = null
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "key_deletion_window" {
  description = "The KMS key deletion window"
  type        = number
  default     = 10
}

variable "recovery_window_in_days" {
  description = "recovery window secrets"
  type        = number
  default     = 30
}
