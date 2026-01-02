
variable "oss_collection_name" {
  type = string
  default = "oss_collection_default"
}



variable "knowledge_base_role_arn" {
  type        = string
  description = "kb  role arn"
}



variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}


variable "security_group_id" {
  description = "Name of the security group id"
  type        = string
}


variable "vpc_endpoint_security_group_id" {
  description = "vpc endpoint security group id"
  type        = string
}

variable "endpoint_subnet_ids" {
  description = "vpc endpoint subnet ids"
  type        = list(string)
}


variable "number_of_shards" {
  type = string
  default = "2"
}

variable "number_of_replicas" {
  type = string
  default = "0"
}

variable "index_knn" {
  type = bool
  default = true
}

variable "index_knn_algo_param_ef_search" {
  type = string
  default = "512"
}


variable "vector_index_name" {
  type        = string
  description = "Name for the vector index"
  default     = "bedrock-knowledge-base-default-index"
}


variable "env" {
  type        = string
  description = "env"
  default = "dev"
}

variable "project_name" {
  type        = string
  description = "project name"
  default = "project"
}
