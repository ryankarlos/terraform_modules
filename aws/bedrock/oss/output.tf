
output "oss_endpoint" {
  value = aws_opensearchserverless_collection.collection.collection_endpoint
}

output "oss_collection_arn" {
  description = "OpenSearch Serverless collection ARN"
  value       = aws_opensearchserverless_collection.collection.arn
}

