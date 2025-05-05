
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
}


resource "aws_lb_target_group" "ip" {
  name        = "ip-target"
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
              minimum_healthy_targets_count      = 1
              minimum_healthy_targets_percentage = "off" 
            }
      unhealthy_state_routing {
              minimum_healthy_targets_count      = 1
              minimum_healthy_targets_percentage = "off"
            }
    }


}

