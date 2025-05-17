variable "subdomain" {
  description = "subdomain for route53 record"
  type        = string
}

variable "hosted_zone_name" {
  description = "route53 private hosted zone name"
  type        = string
}

variable "alias_name" {
  description = "dns domain name for CloudFront distribution, S3 bucket, ELB, AWS Global Accelerator, or another resource record set in this hosted zone."
  type        = string
}


variable "alias_zone_id" {
  description = "Hosted zone ID for alias record"
  type        = string
}

variable "private_hosted_zone" {
  description = "private or public hosted zone"
  type = bool
  default = false
}