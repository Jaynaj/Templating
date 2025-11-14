output "id" {
  description = "ID of the listener"
  value       = aws_lb_listener.this.id
}

output "arn" {
  description = "ARN of the listener"
  value       = try(aws_lb_listener.this.arn, null)
}
