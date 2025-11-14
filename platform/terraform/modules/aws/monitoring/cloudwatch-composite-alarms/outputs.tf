output "id" {
  description = "ID of the alarm"
  value       = aws_cloudwatch_composite_alarm.this.id
}

output "arn" {
  description = "ARN of the alarm"
  value       = try(aws_cloudwatch_composite_alarm.this.arn, null)
}
