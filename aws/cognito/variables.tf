variable "cognito_user_pool_name" {
  description = "name of cognito user pool"
  type        = string
  default     = "prometheus_cognito_pool"
}


variable "cognito_app_client_name" {
  description = "name of cognito app client"
  type        = string
}


variable "saml_metadata_url" {
  description = "URL to the SAML provider metadata document"
  type        = string
  default = "https://replace_this_placeholder"
}

variable "allowed_oauth_flows" {
  description = "List of allowed OAuth flows"
  type        = list(string)
  default     = ["code"]
}

variable "allowed_oauth_scopes" {
  description = "List of allowed OAuth scopes"
  type        = list(string)
  default     = ["email", "openid", "aws.cognito.signin.user.admin"]
}

variable "cognito_saml_attribute_mapping" {
  description = "SAML attribute mapping"
  type        = map(string)
  default = {
    "custom:group" = "http://schemas.microsoft.com/ws/2008/06/identity/claims/groups"
    "custom:department" = "http://schemas.microsoft.com/ws/2008/06/identity/claims/Department"
    email = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    given_name = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
    name = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"
    family_name = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"
    }
}


variable "enable_entraid_auth" {
  description = "whether to use auth via cognito user pool or entraid. defaults to cognito user pool"
  type        = bool
  default     = false
}


variable "callback_urls" {
  description = "login urls for cognito client.Default to main entain sharepoint page if not specified"
  type        = list(string)
  default     = ["https://coralracing.sharepoint.com/sites/EntainMe"]
}


variable "logout_urls" {
  description = "logout urls for cognito client. Default to main entain sharepoint page if not specified"
  type        = list(string)
  default     = ["https://coralracing.sharepoint.com/sites/EntainMe"]
}

variable "access_token_validity" {
  type        = number
  description = "cognito access token expiry time"
  default = 60
}

variable "id_token_validity" {
  type        = number
  description = "cognito id token validity time"
  default = 60
}

variable "refresh_token_validity" {
  type        = number
  description = "cognito refresh token validity time"
  default = 30  
}


variable token_validity_units {
  type = object({
      access_token = string
      id_token = string
      refresh_token = string
    })
  description = "units for token validity"
  default = {
    access_token  = "minutes"
    id_token      = "minutes"
    refresh_token = "days"
  }
}