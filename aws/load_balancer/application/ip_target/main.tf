
module "load_balancer" {
  source = "../"
  vpc_id = var.vpc_id
  subnet_ids = var.subnet_ids
  certificate_arn = var.certificate_arn
  trust_store_bucket = var.trust_store_bucket
  trust_store_name = var.trust_store_name
  target_group_arn = aws_lb_target_group.ip.arn
  tag = var.tag
  security_group_id = var.security_group_id
  alb_name = var.alb_name
  cert_s3_key = var.cert_s3_key
  enable_mutual_authentication = var.enable_mutual_authentication
  enable_cognito_authentication = var.enable_cognito_authentication
  user_pool_client_id  = var.user_pool_client_id
  user_pool_domain = var.user_pool_domain
  user_pool_arn = var.user_pool_arn
  enable_http_listener = var.enable_http_listener
  ssl_policy = var.ssl_policy
  auth_cookie_timeout = var.auth_cookie_timeout
}


resource "aws_lb_target_group" "ip" {
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
  
  deregistration_delay = var.deregistration_delay

  stickiness {
    enabled         = var.stickiness_enabled
    type            = var.stickiness_type
    cookie_duration = var.stickiness_cookie_duration
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

