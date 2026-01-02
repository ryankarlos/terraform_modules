
output "arn" {
  description = "API Gateway arn"
  value       = aws_api_gateway_rest_api.rest_api.arn
}


output "execution_arn" {
  description = " Execution ARN part to be used in lambda_permission's source_arn when allowing API Gateway to invoke a Lambda function, "
  value       = aws_api_gateway_rest_api.rest_api.execution_arn
}

output "id" {
  description = "id of the rest api"
  value       = aws_api_gateway_rest_api.rest_api.id
}

output "resource_id" {
  description = "api gateway resource id"
  value       = aws_api_gateway_resource.resource.id
}

output "method_id" {
  description = "api gateway method id"
  value       = aws_api_gateway_method.method.id
}


output "http_method" {
  description = "http method"
  value       = aws_api_gateway_method.method.http_method
}



output "regional_domain_name" {
  description = "Hostname for the custom domain's regional endpoint."
  value       = aws_api_gateway_domain_name.api_domain.regional_domain_name
}


output "regional_zone_id" {
  description = " Hosted zone ID that can be used to create a Route53 alias record for the regional endpoint."
  value       = aws_api_gateway_domain_name.api_domain.regional_zone_id
}


output "endpoint_private_ips" {
  description = "Private IPs of the API Gateway VPC endpoint"
  value = local.endpoint_ips
}


output "lambda_id" {
  description = "Lambda function ARN"
  value       = aws_api_gateway_integration.lambda.id
}

output "uri" {
  description = "Lambda function ARN"
  value       = aws_api_gateway_integration.lambda.uri
}
