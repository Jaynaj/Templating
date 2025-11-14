output "id" {
  description = "ID of the gateway"
  value       = aws_internet_gateway.this.id
}

output "arn" {
  description = "ARN of the gateway"
  value       = try(aws_internet_gateway.this.arn, null)
}
