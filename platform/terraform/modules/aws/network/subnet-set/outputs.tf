output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "database_subnet_ids" {
  description = "List of database subnet IDs"
  value       = [for subnet in aws_subnet.database : subnet.id]
}

output "public_subnet_cidrs" {
  description = "List of public subnet CIDR blocks"
  value       = [for subnet in aws_subnet.public : subnet.cidr_block]
}

output "private_subnet_cidrs" {
  description = "List of private subnet CIDR blocks"
  value       = [for subnet in aws_subnet.private : subnet.cidr_block]
}

output "database_subnet_group_name" {
  description = "Name of the database subnet group"
  value       = try(aws_db_subnet_group.this[0].name, null)
}

output "database_subnet_group_id" {
  description = "ID of the database subnet group"
  value       = try(aws_db_subnet_group.this[0].id, null)
}
