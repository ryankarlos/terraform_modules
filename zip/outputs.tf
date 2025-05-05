

output "arn" {
  description = "lambda function arn"
  value       = aws_lambda_function.this.arn
}

output "qualified_arn" {
  description = "ARN identifying your Lambda Function Version (if versioning is enabled)"
  value       = aws_lambda_function.this.qualified_arn
}


output "invoke_arn" {
  description = " ARN to be used for invoking Lambda Function from API Gateway "
  value       = aws_lambda_function.this.invoke_arn
}

