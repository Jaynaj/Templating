output "id" {
  description = "ID of the endpoint"
  value       = aws_vpc_endpoint.this.id
}

output "arn" {
  description = "ARN of the endpoint"
  value       = try(aws_vpc_endpoint.this.arn, null)
}
