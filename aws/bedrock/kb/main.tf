data "aws_region" "current" {}
data "aws_caller_identity" "current" {}


resource "aws_vpc_endpoint" "bedrock_runtime" {
  count              = var.create_base_bedrock_endpoints ? 1 : 0
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.bedrock-runtime"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.endpoint_subnet_ids
  private_dns_enabled = true
  security_group_ids = [var.vpc_endpoint_security_group_id]

  tags = {
    Name = "bedrock_runtime_endpoint"
  }
}

resource "aws_vpc_endpoint" "bedrock_agentruntime" {
  count              = var.create_base_bedrock_endpoints ? 1 : 0
  service_name        = "com.amazonaws.${data.aws_region.current.name}.bedrock-agent-runtime"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  vpc_id              = var.vpc_id
  subnet_ids          = var.endpoint_subnet_ids
  security_group_ids  = [var.vpc_endpoint_security_group_id]

  tags = {
    Name = "bedrock-agent-endpoint"
  }
}




resource "aws_vpc_endpoint" "bedrock_agent_build" {
  count              = var.create_bedrock_agent_build_endpoint ? 1 : 0
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${data.aws_region.current.name}.bedrock-agent"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = var.endpoint_subnet_ids
  security_group_ids  = [var.vpc_endpoint_security_group_id]
  private_dns_enabled = true

  tags = {
    Name        = "bedrock-agent-build"
    Project     = var.project_name
    Environment = var.env
  }
}



resource "aws_bedrockagent_data_source" "main" {
  knowledge_base_id = aws_bedrockagent_knowledge_base.main.id
  name              = var.data_source_name

  data_source_configuration {
    type = "S3"
    s3_configuration {
      bucket_arn         =  var.data_source_bucket_arn
      inclusion_prefixes = [var.data_source_prefix]
    }
  }

   # Only include vector_ingestion_configuration if not using DEFAULT strategy
  dynamic "vector_ingestion_configuration" {
    for_each = var.chunking_strategy != "DEFAULT" ? [1] : []
    content {
      chunking_configuration {
        chunking_strategy = var.chunking_strategy

        dynamic "fixed_size_chunking_configuration" {
          for_each = var.chunking_strategy == "FIXED_SIZE" ? [1] : []
          content {
            max_tokens         = var.fixed_size_max_tokens
            overlap_percentage = var.fixed_size_overlap_percentage
          }
        }

        dynamic "hierarchical_chunking_configuration" {
          for_each = var.chunking_strategy == "HIERARCHICAL" ? [1] : []
          content {
            overlap_tokens = var.hierarchical_overlap_tokens
            level_configuration {
              max_tokens = var.hierarchical_parent_max_tokens
            }
            level_configuration {
              max_tokens = var.hierarchical_child_max_tokens
            }
          }
        }

        dynamic "semantic_chunking_configuration" {
          for_each = var.chunking_strategy == "SEMANTIC" ? [1] : []
          content {
            max_token                      = var.semantic_max_tokens
            buffer_size                    = var.semantic_buffer_size
            breakpoint_percentile_threshold = var.semantic_breakpoint_percentile_threshold
          }
        }
      }
    }
  }

}



resource "aws_bedrockagent_knowledge_base" "main" {
  name       = var.knowledge_base_name
  role_arn   = var.kb_role_arn

  knowledge_base_configuration {
    vector_knowledge_base_configuration {
      embedding_model_arn = var.bedrock_embedding_model_arn
    }
    type = "VECTOR"
  }

  storage_configuration {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration {
      collection_arn    = var.oss_collection_arn
      vector_index_name = var.vector_index_name
      field_mapping {
        vector_field   = "bedrock-knowledge-base-default-vector"
        text_field     = "AMAZON_BEDROCK_TEXT_CHUNK"
        metadata_field = "AMAZON_BEDROCK_METADATA"
      }
    }
  }
}

