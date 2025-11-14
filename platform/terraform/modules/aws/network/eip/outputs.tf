output "id" {
  description = "ID of the eip"
  value       = aws_eip.this.id
}

output "arn" {
  description = "ARN of the eip"
  value       = try(aws_eip.this.arn, null)
}
