# use this module if you need to create new service on existing cluster




resource "aws_ecs_task_definition" "ecs_task_definition" {
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
  name                          = var.service_name
  cluster                       = var.cluster_arn
  task_definition               = aws_ecs_task_definition.ecs_task_definition.arn
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
      target_group_arn = aws_lb_target_group.target_group.arn
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
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.ecs_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


# Step Scaling Policy - Target Tracking
resource "aws_appautoscaling_policy" "ecs_policy" {
  count              = var.scaling_type == "step" ? 1 : 0
  name               = "${var.service_name}-step-scaling"
  policy_type        = "StepScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

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
  count = var.scaling_type == "cpu" ? 1 : 0

  name               = "${var.service_name}-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

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
  count = var.scaling_type == "memory" ? 1 : 0

  name               = "${var.service_name}-memory-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value       = var.memory_target_value
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }
}


resource "aws_lb_listener_rule" "path_routing" {
  count = var.enable_load_balancer ? 1 : 0
  listener_arn = var.listener_arn
  priority     = var.listener_rule_priorty

  # Cognito authentication action (when enabled)
  dynamic "action" {
    for_each = var.enable_cognito_authentication ? [1] : []
    content {
      type = "authenticate-cognito"
      authenticate_cognito {
        user_pool_arn       = var.user_pool_arn
        user_pool_client_id = var.user_pool_client_id
        user_pool_domain    = var.user_pool_domain
        session_timeout = var.auth_cookie_timeout
      }
      order = 1
    }
  }

  # Forward action (always present, but order depends on auth)
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
    order           = var.enable_cognito_authentication ? 2 : 1
  }

  condition {
    path_pattern {
      values = [var.listener_rule_path]
    }
  }

  condition {
    host_header {
      values = [var.host_header_rule]
    }
  }

}




resource "aws_lb_target_group" "target_group" {
  name        = var.target_group_name
  port = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"
  lifecycle {
      create_before_destroy = true
  }

  health_check {
    enabled             = var.health_check_enabled
    matcher            = "200,403"
    path               = var.health_check_path
    protocol           = var.health_check_protocol
  }
  
  stickiness {
    enabled         = false
    type            = "lb_cookie"
  }

  target_group_health {
      dns_failover {
              minimum_healthy_targets_count      = var.minimum_healthy_targets_count
              minimum_healthy_targets_percentage = "off" 
            }
      unhealthy_state_routing {
              minimum_healthy_targets_count      = var.minimum_healthy_targets_count
              minimum_healthy_targets_percentage = "off"
            }
    }


}

