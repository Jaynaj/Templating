output "id" {
  description = "ID of the table"
  value       = aws_route_table.this.id
}

output "arn" {
  description = "ARN of the table"
  value       = try(aws_route_table.this.arn, null)
}
