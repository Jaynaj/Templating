output "db_instance_id" {
  description = "Database instance ID"
  value       = aws_db_instance.this.id
}

output "db_instance_arn" {
  description = "Database instance ARN"
  value       = aws_db_instance.this.arn
}

output "db_instance_endpoint" {
  description = "Database instance endpoint"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_address" {
  description = "Database instance address"
  value       = aws_db_instance.this.address
}

output "db_instance_port" {
  description = "Database instance port"
  value       = aws_db_instance.this.port
}

output "db_instance_name" {
  description = "Database name"
  value       = aws_db_instance.this.db_name
}

output "db_instance_username" {
  description = "Master username"
  value       = aws_db_instance.this.username
  sensitive   = true
}

output "db_instance_resource_id" {
  description = "Database instance resource ID"
  value       = aws_db_instance.this.resource_id
}

output "db_instance_availability_zone" {
  description = "Database instance availability zone"
  value       = aws_db_instance.this.availability_zone
}

output "db_instance_status" {
  description = "Database instance status"
  value       = aws_db_instance.this.status
}

output "option_group_id" {
  description = "Option group ID"
  value       = try(aws_db_option_group.this[0].id, null)
}

output "option_group_arn" {
  description = "Option group ARN"
  value       = try(aws_db_option_group.this[0].arn, null)
}

output "parameter_group_id" {
  description = "Parameter group ID"
  value       = try(aws_db_parameter_group.this[0].id, null)
}

output "parameter_group_arn" {
  description = "Parameter group ARN"
  value       = try(aws_db_parameter_group.this[0].arn, null)
}

output "read_replica_ids" {
  description = "List of read replica IDs"
  value       = aws_db_instance.replica[*].id
}

output "read_replica_endpoints" {
  description = "List of read replica endpoints"
  value       = aws_db_instance.replica[*].endpoint
}

output "connection_string" {
  description = "Oracle connection string (SQL*Plus format)"
  value       = "${var.master_username}@${aws_db_instance.this.address}:${aws_db_instance.this.port}/${aws_db_instance.this.db_name}"
  sensitive   = true
}
