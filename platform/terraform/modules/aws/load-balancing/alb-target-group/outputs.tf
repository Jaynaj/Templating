output "id" {
  description = "ID of the group"
  value       = aws_lb_target_group.this.id
}

output "arn" {
  description = "ARN of the group"
  value       = try(aws_lb_target_group.this.arn, null)
}
