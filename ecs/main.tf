resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  configuration {
    execute_command_configuration {
      logging = var.execute_command_logging
    }
  }

  tags = merge(
    {
      Name = var.cluster_name
    },
    var.tags
  )
}

resource "aws_cloudwatch_log_group" "this" {
  count = var.create_cloudwatch_log_group ? 1 : 0

  name              = "/aws/ecs/${var.cluster_name}"
  retention_in_days = var.cloudwatch_log_retention_days
  kms_key_id        = var.cloudwatch_log_kms_key_id

  tags = merge(
    {
      Name = "/aws/ecs/${var.cluster_name}"
    },
    var.tags
  )
}


resource "aws_ecs_task_definition" "ecs_task_definition" {
  count                    = var.add_service ? 1 : 0
  family                   = var.service_name
  network_mode             = var.launch_type == "FARGATE" ? "awsvpc" : "bridge"
  requires_compatibilities = [var.launch_type]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions    = var.container_definitions
  ephemeral_storage {
    size_in_gib = var.ephemeral_storage
  }

  runtime_platform {
    cpu_architecture        = var.runtime_platform["cpu_architecture"]
    operating_system_family = var.runtime_platform["operating_system_family"]
  }
}


# ECS Service
resource "aws_ecs_service" "ecs_service" {
  count                         = var.add_service ? 1 : 0
  name                          = var.service_name
  cluster                       = aws_ecs_cluster.this.id
  task_definition               = aws_ecs_task_definition.ecs_task_definition[0].arn
  desired_count                 = var.desired_count
  launch_type                   = var.launch_type
  platform_version              = var.launch_type == "FARGATE" ? var.platform_version : null
  scheduling_strategy           = "REPLICA"
  availability_zone_rebalancing = "ENABLED"
  force_new_deployment          = var.force_new_deployment


  dynamic "network_configuration" {
    for_each = var.launch_type == "FARGATE" ? [1] : []
    content {
      assign_public_ip = true
      subnets          = var.subnet_ids
      security_groups  = var.security_group_ids
    }
  }

  dynamic "load_balancer" {
    for_each = var.enable_load_balancer ? [1] : []
    content {
      target_group_arn = var.target_group_arn
      container_name   = var.container_name
      container_port   = var.container_port
    }
  }

  deployment_controller {
    type = var.deployment_controller_type
  }

  deployment_circuit_breaker {
    enable   = var.enable_circuit_breaker
    rollback = var.enable_circuit_breaker_rollback
  }
}


# Auto Scaling
resource "aws_appautoscaling_target" "ecs_target" {
  count              = var.add_service ? 1 : 0
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.ecs_service[0].name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


# Step Scaling Policy - Target Tracking
resource "aws_appautoscaling_policy" "ecs_policy" {
  count              = var.add_service == true && var.scaling_type == "step" ? 1 : 0
  name               = "${var.service_name}-step-scaling"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = var.step_scaling_config.cooldown
    metric_aggregation_type = "Maximum"

    step_adjustment {
      metric_interval_upper_bound = var.step_scaling_config.metric_interval_upper_bound
      scaling_adjustment          = var.step_scaling_config.scaling_adjustment
    }
  }
}

# CPU Target Tracking
resource "aws_appautoscaling_policy" "cpu" {
  count = var.add_service == true && var.scaling_type == "cpu" ? 1 : 0

  name               = "${var.service_name}-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.cpu_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}

# Memory Target Tracking
resource "aws_appautoscaling_policy" "memory" {
  count = var.add_service == true && var.scaling_type == "memory" ? 1 : 0

  name               = "${var.service_name}-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target[0].resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target[0].scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target[0].service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = var.memory_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}
