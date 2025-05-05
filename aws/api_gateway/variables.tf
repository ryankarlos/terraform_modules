
variable "tag" {
  description = "tag object"
   type = object({
    name = string
  })
}

variable "domain_name" {
  description = "Custom domain name for the API"
  type        = string
}

variable "certificate_arn" {
  description = "ACM certificate arn for custom domain"
  type        = string
}


variable "stage_name" {
  description = "api gateway stage name"
  type        = string
}

variable "http_method" {
  description = "method for api gateway e.g. GET, POST"
  type        = string
  default     = "GET"
}


variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}


variable "endpoint_subnet_ids" {
  description = "vpc endpoint subnet ids"
  type        = list(string)
}


variable "vpc_endpoint_security_group_id" {
  description = "vpc endpoint security group id"
  type        = string
}


variable "resource_path" {
  description = "api gateway resource path"
  type        = string
}


variable "lambda_function_invoke_arn" {
  description = "arn of the lambda function for backend"
  type        = string
}

variable "integration_timeout" {
  description = "timeout in milliseconds"
  type        = number
}


variable "validate_request_body" {
  description = "validate request body"
  type        = bool
  default = true
}

variable "validate_request_parameters" {
  description = "validate request parameters"
  type        = bool
  default = true
}

variable "integration_type_lambda" {
  description = "api gateway integration type e.g AWS, AWS_PROXY"
  type        = string
  default = "AWS"
}


variable "integration_http_method" {
  description = "api gateway integration http method"
  type        = string
  default = "POST"
}


variable "model_schema" {
  description = "api gateway model schema"
  type        = string
}



variable "method_authorization" {
  description = "api gateway method authorization"
  type        = string
  default = "NONE"
}


variable "lambda_function_name" {
  description = "name of backend lambda function"
  type        = string
}



variable "response_models" {
  description = "model for the response"
  type        = map(string)
  default = {
    "application/json" = "Empty"
  }
}


variable "response_mapping_template" {
  description = "mapping template for response"
  type        = map(string)
  default = {
     "application/json"  = ""
  }
}




