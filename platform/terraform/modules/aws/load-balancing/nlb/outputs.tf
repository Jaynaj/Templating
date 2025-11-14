output "id" {
  description = "ID of the lb"
  value       = aws_lb.this.id
}

output "arn" {
  description = "ARN of the lb"
  value       = try(aws_lb.this.arn, null)
}
