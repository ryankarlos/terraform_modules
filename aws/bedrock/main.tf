data "aws_region" "current" {}


resource "aws_vpc_endpoint" "bedrock_runtime" {
  count              = var.create_bedrock_vpc_endpoint ? 1 : 0
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


# move this to bedrock module later
resource "aws_vpc_endpoint" "bedrock_agentruntime" {
  count              = var.create_bedrock_vpc_endpoint ? 1 : 0
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


# Bedrock Guardrail
# resource "aws_bedrock_guardrail" "main_guardrail" {
#   name        = var.main_guardrail_name
#   description = "Main guardrail for bedrock"
#   blocked_input_messaging = var.blocked_input_messaging
#   blocked_outputs_messaging = var.blocked_output_messaging

  
#   content_policy_config {
#     filters_config {
#       type = "HATE"
#       input_strength = "HIGH"
#       output_strength = "HIGH"
#     }
#     filters_config {
#       type = "VIOLENCE"
#       input_strength = "HIGH"
#       output_strength = "HIGH"
#     }
#     filters_config {
#       type = "MISCONDUCT"
#       input_strength = "HIGH"
#       output_strength = "HIGH"
#     }
#     filters_config {
#       type = "SEXUAL"
#       input_strength = "HIGH"
#       output_strength = "HIGH"
#     }
#     filters_config {
#       type = "INSULTS"
#       input_strength = "HIGH"
#       output_strength = "HIGH"
#     }
#   }
  
#   sensitive_information_policy_config {
#     pii_entities_config {
#       type = "ADDRESS"
#       action = "ANONYMIZE"
#     }
#     pii_entities_config {
#       type = "EMAIL"
#       action = "ANONYMIZE"
#     }
#      pii_entities_config {
#       type = "PHONE"
#       action = "ANONYMIZE"
#     }
#      pii_entities_config {
#       type = "NAME"
#       action = "ANONYMIZE"
#     }
#      pii_entities_config {
#       type = "AGE"
#       action = "ANONYMIZE"
#     }
#      pii_entities_config {
#       type = "USERNAME"
#       action = "ANONYMIZE"
#     }
#       pii_entities_config {
#       type = "PASSWORD"
#       action = "ANONYMIZE"
#     }
#     pii_entities_config {
#       type = "DRIVER_ID"
#       action = "ANONYMIZE"
#     }
#      pii_entities_config {
#       type = "VEHICLE_IDENTIFICATION_NUMBER"
#       action = "ANONYMIZE"
#     }
#   }
  
#   topic_policy_config {
#     topics_config {
#       name = "finance"
#       type = "DENY"
#       definition = "Queries related to financial advice such as: cryptocurrencies, pensions, investments, ISAs, retail or investment banking, trading platforms, CFD trading, crpyto exchanges."
#     }
#   }

#   word_policy_config {
#     managed_word_lists_config {
#       type = "PROFANITY"
#     }
#   }
  
#   tags = var.tag
# }



# # Bedrock Guardrail Version
# resource "aws_bedrock_guardrail_version" "main_guardrail_version" {
#   guardrail_arn = aws_bedrock_guardrail.main_guardrail.guardrail_arn
# }

