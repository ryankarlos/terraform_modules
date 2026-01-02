output "cognito_user_pool_domain_prefix" {
  description = "cognito user pool domain"
  value       = aws_cognito_user_pool.user_pool.domain
}


output "cognito_user_pool_domain_url" {
  description = "cognito user pool domain full url"
  value       = "https://${aws_cognito_user_pool.user_pool.domain}.auth.${data.aws_region.current.name}.amazoncognito.com"
}

output "cognito_user_pool_id" {
  description = "cognito user pool id"
  value       = aws_cognito_user_pool.user_pool.id
}

output "cognito_user_pool_arn" {
  description = "cognito user pool arn"
  value       = aws_cognito_user_pool.user_pool.arn
}

output "cognito_app_client_id" {
  description = "cognito client app id"
  value       = aws_cognito_user_pool_client.client.id
}


output "cognito_app_client_secret" {
  description = "cognito client app secret"
  value       = aws_cognito_user_pool_client.client.client_secret
}
