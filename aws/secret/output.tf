output "secret_name" {
  description = "The name of the secret"
  value       = aws_secretsmanager_secret.this.name
}

output "secret_arn" {
  description = "The ARN of the secret"
  value       = aws_secretsmanager_secret.this.arn
}


output "secret_string" {
  description = "The ARN of the secret"
  value       = aws_secretsmanager_secret_version.this.secret_string
}

output "secret_version_arn" {
  description = "The ARN of the secret version"
  value       = aws_secretsmanager_secret_version.this.arn
}

