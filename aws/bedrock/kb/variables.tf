variable "create_base_bedrock_endpoints" {
  type    = bool
  description = "whether to create main bedrock endppints bedrock-agent-runtime and bedrock-runtime"
  default = false
}

variable "create_bedrock_agent_build_endpoint" {
  type    = bool
  description = "creates bedrock agent kb endpoint. set to false if already exists"
  default = true
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



variable "vector_dimension" {
  description = "The dimension of the vectors produced by the model."
  type        = number
  default     = 1024
}


variable "chunking_strategy" {
  type        = string
  description = "Chunking strategy to use (DEFAULT, FIXED_SIZE, HIERARCHICAL, SEMANTIC)"
  default     = "FIXED_SIZE"
  validation {
    condition     = contains(["DEFAULT", "FIXED_SIZE", "HIERARCHICAL", "SEMANTIC", "NONE"], var.chunking_strategy)
    error_message = "Chunking strategy must be one of: DEFAULT, FIXED_SIZE, HIERARCHICAL, SEMANTIC, NONE"
  }
}

# Fixed Size Chunking Variables
variable "fixed_size_max_tokens" {
  type        = number
  description = "Maximum number of tokens for fixed-size chunking"
  default     = 512
}

variable "fixed_size_overlap_percentage" {
  type        = number
  description = "Percentage of overlap between chunks"
  default     = 20
}

# Hierarchical Chunking Variables
variable "hierarchical_overlap_tokens" {
  type        = number
  description = "Number of tokens to overlap in hierarchical chunking"
  default     = 70
}

variable "hierarchical_parent_max_tokens" {
  type        = number
  description = "Maximum tokens for parent chunks"
  default     = 1000
}

variable "hierarchical_child_max_tokens" {
  type        = number
  description = "Maximum tokens for child chunks"
  default     = 500
}

# Semantic Chunking Variables
variable "semantic_max_tokens" {
  type        = number
  description = "Maximum tokens for semantic chunking"
  default     = 512
}

variable "semantic_buffer_size" {
  type        = number
  description = "Buffer size for semantic chunking"
  default     = 1
}

variable "semantic_breakpoint_percentile_threshold" {
  type        = number
  description = "Breakpoint percentile threshold for semantic chunking"
  default     = 75
}

variable "bedrock_embedding_model_arn" {
  type        = string
  description = "Embedding model for Knowledge base"
}

variable "kb_role_arn" {
  type        = string
  description = "Kb role arn"
}


variable "data_source_name" {
  type        = string
  description = "Name for the data source"
  default     = "s3-data-source"
}


variable "data_source_bucket_arn" {
  type        = string
  description = "bucket_arn"
}


variable "oss_collection_arn" {
  type        = string
  description = "oss_collection_arn"
}

variable "oss_collection_name" {
  type        = string
  description = "oss_collection_name"
}

variable "data_source_prefix" {
  type        = string
  description = "Name for the data source bucket prefix"
}

variable "knowledge_base_name" {
  type        = string
  description = "name of the knowledge base"
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

variable "vector_index_name" {
  type        = string
  description = "Name for the vector index"
  default     = "bedrock-knowledge-base-default-index"
}
