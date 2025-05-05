output "domain_id" {
  description = "The ID of the SageMaker Domain"
  value       = aws_sagemaker_domain.domain.id
}

output "domain_url" {
  description = "The URL of the SageMaker Domain"
  value       = aws_sagemaker_domain.domain.url
}

output "execution_role_arn" {
  description = "The ARN of the execution role"
  value       = aws_iam_role.admin.arn
}
