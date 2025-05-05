output "record_fqdn" {
  description = "fully qualified domain name of record"
  value       = aws_route53_record.alias_record.fqdn
}

output "record_name" {
  description = "Name of the alias record"
  value       = aws_route53_record.alias_record.name
}

