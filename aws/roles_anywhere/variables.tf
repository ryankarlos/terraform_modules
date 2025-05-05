
variable "role_name" {
  type    = string
  default = "RolesAnywhereDSRole"
}

variable "trust_anchor_name" {
  type    = string
  default = "RolesAnywhereTrustAnchor"
}


variable "profile_name" {
  type    = string
  default = "RolesAnywhereDSProfile"
}


variable "acm_pca_arn" {
  type = string
}
