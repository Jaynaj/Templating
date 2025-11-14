output "id" {
  description = "ID of the instance"
  value       = aws_db_instance.this.id
}

output "arn" {
  description = "ARN of the instance"
  value       = try(aws_db_instance.this.arn, null)
}
