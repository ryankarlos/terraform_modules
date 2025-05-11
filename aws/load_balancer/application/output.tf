output "arn" {
  description = "ARN of the internal ALB"
  value       = aws_lb.internal.arn
}

output "dns" {
  description = "DNS name of the internal ALB"
  value       = "dualstack.${aws_lb.internal.dns_name}"
}

output "zone_id" {
  description = "Canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
  value       = aws_lb.internal.zone_id
}


