output "service_id" {
  description = "The ID of the ECS service"
  value       = aws_ecs_service.ecs_service.id
}

output "task_definition_arn" {
  description = "The ARN of the Task Definition"
  value       =  aws_ecs_task_definition.ecs_task_definition.arn
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
