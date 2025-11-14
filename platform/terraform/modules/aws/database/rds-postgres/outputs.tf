output "id" {
  description = "DB instance ID"
  value       = aws_db_instance.this.id
}

output "arn" {
  description = "DB instance ARN"
  value       = aws_db_instance.this.arn
}

output "endpoint" {
  description = "DB endpoint"
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "DB address"
  value       = aws_db_instance.this.address
}

output "port" {
  description = "DB port"
  value       = aws_db_instance.this.port
}
