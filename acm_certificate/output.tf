output "certificate_arn" {
  description = "ACM certificate arn"
  value       = aws_acm_certificate.api_cert.arn
}

output "status" {
  description = "ACM certificate status"
  value       = aws_acm_certificate.api_cert.status
}

output "domain_name" {
  description = "Domain name for which the certificate is issued"
  value       = aws_acm_certificate.api_cert.domain_name
}


output "expiration_date" {
  description = "expiration date of ACM cert"
  value       = aws_acm_certificate.api_cert.not_after
}


output "validity_start_date" {
  description = "Validity start date of ACM certficate"
  value       = aws_acm_certificate.api_cert.not_before
}
