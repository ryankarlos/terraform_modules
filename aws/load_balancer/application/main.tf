
resource "aws_lb" "internal" {
  name               = var.alb_name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.security_group_id]
  idle_timeout = var.idle_timeout
  enable_deletion_protection = var.enable_deletion_protection
  drop_invalid_header_fields = true
  dynamic "subnet_mapping" {
    for_each = toset(var.subnet_ids)
    content {
      subnet_id = subnet_mapping.value
    }
  }
}


resource "aws_lb_listener" "internal_https" {
  load_balancer_arn = aws_lb.internal.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn


  mutual_authentication {
       mode = var.enable_mtls ? "verify" : "off"
       trust_store_arn = var.enable_mtls ? var.trust_store_arn : null
     }

  default_action {
    type             = "forward"
     target_group_arn = var.target_group_arn 
  }
}


resource "aws_lb_listener" "frontend_http" {
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn = var.target_group_arn 
    type             = "forward"
  }
}

