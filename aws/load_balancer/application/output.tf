output "arn" {
  description = "ARN of the internal ALB"
  value       = aws_lb.lb.arn
}

output "dns" {
  description = "DNS name of the internal ALB"
  value       = "dualstack.${aws_lb.lb.dns_name}"
}

output "zone_id" {
  description = "Canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
  value       = aws_lb.lb.zone_id
}


