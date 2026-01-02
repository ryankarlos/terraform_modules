output "datasync_task_arn" {
  description = "ARN of the DataSync task"
  value       = aws_datasync_task.s3tos3.arn
}
