output "id" {
  description = "ID of the record"
  value       = aws_route53_record.this.id
}

output "arn" {
  description = "ARN of the record"
  value       = try(aws_route53_record.this.arn, null)
}
