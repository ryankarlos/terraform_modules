output "key_id" {
  description = "The key ID"
  value       = aws_kms_key.this.key_id
}

output "key_arn" {
  value       = aws_kms_key.this.arn
  description = "The arn of this key"
}

output "key_alias_arn" {
  description = "The key alias arn"
  value       = aws_kms_alias.this.arn
}

output "key_alias" {
  description = "The key alias"
  value       = aws_kms_alias.this.name
}

