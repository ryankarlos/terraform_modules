output "s3_bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.this.arn
}

output "s3_bucket_id" {
  description = "s3 bucket name"
  value       = aws_s3_bucket.this.id
}
