output "id" {
  description = "ID of the zone"
  value       = aws_route53_zone.this.id
}

output "arn" {
  description = "ARN of the zone"
  value       = try(aws_route53_zone.this.arn, null)
}
