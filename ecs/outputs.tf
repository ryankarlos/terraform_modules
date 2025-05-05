output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.this.id
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.this.arn
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "log_group_name" {
  description = "Name of the CloudWatch log group for the ECS cluster"
  value       = var.create_cloudwatch_log_group ? aws_cloudwatch_log_group.this[0].name : null
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group for the ECS cluster"
  value       = var.create_cloudwatch_log_group ? aws_cloudwatch_log_group.this[0].arn : null
}

output "service_id" {
  description = "The ID of the ECS service"
  value       = var.add_service ? aws_ecs_service.ecs_service[0].id : null
}

output "task_definition_arn" {
  description = "The ARN of the Task Definition"
  value       = var.add_service ? aws_ecs_task_definition.ecs_task_definition[0].arn : null
}

output "ecs_execution_role_arn" {
  description = "ARN of ECS execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "ARN of ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_execution_role_name" {
  description = "Name of ECS execution role"
  value       = aws_iam_role.ecs_execution_role.name
}

output "ecs_task_role_name" {
  description = "Name of ECS task role"
  value       = aws_iam_role.ecs_task_role.name
}
