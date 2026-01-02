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
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  dynamic "mutual_authentication" {
    for_each = var.enable_mutual_authentication ? [1] : []
    content {
      mode            = "verify"
      trust_store_arn = aws_lb_trust_store.this[0].arn
    }
  }

  dynamic "default_action" {
    for_each = var.enable_cognito_authentication ? [1] : []
    content {
      type = "authenticate-cognito"
      authenticate_cognito {
        user_pool_arn       = var.user_pool_arn
        user_pool_client_id = var.user_pool_client_id
        user_pool_domain    = var.user_pool_domain
        session_timeout = var.auth_cookie_timeout
      }
    }
  }

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn 
  }
}


resource "aws_lb_listener" "frontend_http" {
  count = var.enable_http_listener ? 1 : 0
  load_balancer_arn = aws_lb.internal.arn
  port              = 80
  protocol          = "HTTP"
  
  default_action {
    target_group_arn = var.target_group_arn 
    type             = "forward"
  }
}


# Trust store resource - only created if mutual auth is enabled
resource "aws_lb_trust_store" "this" {
    count = var.enable_mutual_authentication ? 1 : 0
    ca_certificates_bundle_s3_bucket = var.trust_store_bucket
    ca_certificates_bundle_s3_key = var.cert_s3_key
    name = var.trust_store_name
}