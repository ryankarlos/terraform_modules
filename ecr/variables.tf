variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
  type        = string
  default     = "MUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Valid values for image_tag_mutability are (MUTABLE, IMMUTABLE)."
  }
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images"
  type        = bool
  default     = false
}

variable "encryption_type" {
  description = "The encryption type to use for the repository. Valid values are AES256 or KMS"
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "Valid values for encryption_type are (AES256, KMS)."
  }
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key to use when encryption_type is KMS. If not specified, uses the default AWS managed key"
  type        = string
  default     = null
}

variable "enable_tag_expiration" {
  description = "Enable lifecycle policy for tagged images"
  type        = bool
  default     = true
}

variable "enable_untagged_expiration" {
  description = "Enable lifecycle policy for untagged images"
  type        = bool
  default     = true
}

variable "default_max_image_count" {
  description = "Default maximum number of tagged images to keep (used when a specific tag prefix is not in max_image_count_map)"
  type        = number
  default     = 30
}

variable "max_image_count_map" {
  description = "Map of tag prefixes to maximum number of images to keep for each prefix"
  type        = map(number)
  default = {
    "feat-" = 30 # Default for GitLab CI_COMMIT_SHORT_SHA
  }
}

variable "tag_prefix_list" {
  description = "List of tag prefixes to apply the lifecycle policy to"
  type        = list(string)
  default     = ["sha-"]
}

variable "untagged_image_expiration_days" {
  description = "Number of days after which untagged images will expire"
  type        = number
  default     = 14
}

variable "repository_policy" {
  description = "JSON formatted ECR repository policy"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
