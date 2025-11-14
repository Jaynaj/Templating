output "id" {
  description = "ID of the subnet"
  value       = aws_subnet.this.id
}

output "arn" {
  description = "ARN of the subnet"
  value       = try(aws_subnet.this.arn, null)
}
