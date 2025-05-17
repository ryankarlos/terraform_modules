
output "arn" {
  description = "ARN of the internal ALB"
  value       = module.load_balancer.arn
}

output "target_group_arn" {
  description = "ARN of the target group arn"
  value       = aws_lb_target_group.ip.arn
}


output "dns" {
  description = "DNS name of the internal ALB"
  value       = module.load_balancer.dns
}

output "zone_id" {
  description = "Canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
  value       = module.load_balancer.zone_id
}
