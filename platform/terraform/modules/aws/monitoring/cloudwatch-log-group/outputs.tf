output "id" {
  description = "ID of the group"
  value       = aws_cloudwatch_log_group.this.id
}

output "arn" {
  description = "ARN of the group"
  value       = try(aws_cloudwatch_log_group.this.arn, null)
}
