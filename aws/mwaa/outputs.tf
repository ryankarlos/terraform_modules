output "mwaa_environment_arn" {
  description = "The ARN of the MWAA environment"
  value       = aws_mwaa_environment.dsai_pub.arn
}

output "mwaa_environment_name" {
  description = "The name of the MWAA environment"
  value       = aws_mwaa_environment.dsai_pub.name
}

output "mwaa_webserver_url" {
  description = "The webserver URL of the MWAA environment"
  value       = aws_mwaa_environment.dsai_pub.webserver_url
}

output "mwaa_service_role_arn" {
  description = "The service role ARN of the MWAA environment"
  value       = aws_iam_role.role.arn
}

output "mwaa_bucket_arn" {
  description = "The ARN of the S3 bucket used for MWAA"
  value       = module.dsai_mwaa_bucket.s3_bucket_arn
}

output "mwaa_bucket_name" {
  description = "The name of the S3 bucket used for MWAA"
  value       = module.dsai_mwaa_bucket.s3_bucket_id
}

