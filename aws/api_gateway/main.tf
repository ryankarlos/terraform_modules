

resource "aws_api_gateway_rest_api" "rest_api" {
  endpoint_configuration {
    types = [
      "PRIVATE"
    ]
    vpc_endpoint_ids = var.create_vpc_endpoint ? [aws_vpc_endpoint.api_gateway[0].id] : var.external_vpc_endpoint_ids

  }
  disable_execute_api_endpoint = true
  name = var.tag.name
}

resource "aws_api_gateway_resource" "resource" {
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = var.resource_path
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}




resource "aws_api_gateway_method" "method" {
  authorization = var.method_authorization
  http_method   = var.http_method
  resource_id   = aws_api_gateway_resource.resource.id
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  request_models       = {
         "application/json" =var.model_name
        }
  request_validator_id = aws_api_gateway_request_validator.example.id

  depends_on = [aws_api_gateway_model.model]
}


resource "aws_api_gateway_request_validator" "example" {
  name                        = "request_validator"
  rest_api_id                 = aws_api_gateway_rest_api.rest_api.id
  validate_request_body       = var.validate_request_body
  validate_request_parameters = var.validate_request_parameters
}

# API Gateway Domain Name
resource "aws_api_gateway_domain_name" "api_domain" {
  domain_name              = var.domain_name
  regional_certificate_arn = var.certificate_arn
  
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_stage" "this" {
  deployment_id = aws_api_gateway_deployment.deployment.id
  rest_api_id  = aws_api_gateway_rest_api.rest_api.id
  stage_name   = var.stage_name
}


resource "aws_api_gateway_base_path_mapping" "this" {
  api_id      = aws_api_gateway_rest_api.rest_api.id
  stage_name  = aws_api_gateway_stage.this.stage_name
  domain_name = aws_api_gateway_domain_name.api_domain.domain_name

  depends_on = [
    aws_api_gateway_stage.this
  ]
}

resource "aws_vpc_endpoint" "api_gateway" {

  count               = var.create_vpc_endpoint ? 1 : 0
  private_dns_enabled = true
  security_group_ids  = [var.vpc_endpoint_security_group_id]
  service_name        = "com.amazonaws.${data.aws_region.current.name}.execute-api"
  subnet_ids          = var.endpoint_subnet_ids
  vpc_endpoint_type   = "Interface"
  vpc_id              = var.vpc_id
}


resource "aws_api_gateway_rest_api_policy" "resource_policy" {
  rest_api_id =  aws_api_gateway_rest_api.rest_api.id
  policy      = data.aws_iam_policy_document.policy.json
}

resource "aws_api_gateway_integration" "lambda" {
  content_handling = "CONVERT_TO_TEXT"
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method

  integration_http_method =  var.integration_http_method
  type                   = var.integration_type_lambda
  uri                    = var.lambda_function_invoke_arn
  timeout_milliseconds = var.integration_timeout
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowMyAPIInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "apigateway.amazonaws.com"

  # The /* part allows invocation from any stage, method and resource path
  # within API Gateway.
  source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*"
}


resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id =  aws_api_gateway_rest_api.rest_api.id
    
  triggers = {
    # Hash of all resources that should trigger a redeployment
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource,
      aws_api_gateway_method.method,
      aws_api_gateway_integration.lambda,
      aws_api_gateway_model.model,
      aws_api_gateway_method_response.response_200,
      aws_api_gateway_integration_response.IntegrationResponse,
      aws_api_gateway_request_validator.example,
      aws_api_gateway_rest_api_policy.resource_policy,
    ]))
  }
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_method.method,
    aws_api_gateway_model.model,
    aws_api_gateway_method_response.response_200,
    aws_api_gateway_integration_response.IntegrationResponse,
    aws_api_gateway_request_validator.example,
    aws_api_gateway_rest_api_policy.resource_policy
    ]

  lifecycle {
    create_before_destroy = true
  }
}

# api gateway model
resource "aws_api_gateway_model" "model" {
  rest_api_id  = aws_api_gateway_rest_api.rest_api.id
  name         = var.model_name
  content_type = "application/json"

  schema = var.model_schema
}


resource "aws_api_gateway_method_response" "response_200" {
   depends_on  = [aws_api_gateway_integration.lambda]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = 200
  response_models = var.response_models

  response_parameters = {
    "method.response.header.Content-Type" = true
  }
}

resource "aws_api_gateway_integration_response" "IntegrationResponse" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code
  response_templates = var.response_mapping_template
}