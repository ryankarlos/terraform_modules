
resource "aws_acm_certificate" "api_cert" {
  domain_name       = var.domain_name
  certificate_authority_arn = var.certificate_authority_arn

  lifecycle {
    create_before_destroy = true
  }

}
