output "id" {
  description = "ID of the group"
  value       = aws_xray_group.this.id
}

output "arn" {
  description = "ARN of the group"
  value       = try(aws_xray_group.this.arn, null)
}
