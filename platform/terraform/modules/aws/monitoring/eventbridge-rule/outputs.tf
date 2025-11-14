output "id" {
  description = "ID of the rule"
  value       = aws_cloudwatch_event_rule.this.id
}

output "arn" {
  description = "ARN of the rule"
  value       = try(aws_cloudwatch_event_rule.this.arn, null)
}
