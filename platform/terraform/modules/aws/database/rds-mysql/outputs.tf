output "db_instance_id" {
  description = "DB instance ID"
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "DB instance ARN"
  value       = aws_db_instance.this.arn
}

output "db_instance_endpoint" {
  description = "DB endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_address" {
  description = "DB address"
  value       = aws_db_instance.this.address
}

output "db_instance_port" {
  description = "DB port"
  value       = aws_db_instance.this.port
}

output "db_instance_resource_id" {
  description = "DB resource ID"
  value       = aws_db_instance.this.resource_id
}

output "replica_endpoints" {
  description = "Read replica endpoints"
  value       = aws_db_instance.replica[*].endpoint
}

output "replica_addresses" {
  description = "Read replica addresses"
  value       = aws_db_instance.replica[*].address
}
