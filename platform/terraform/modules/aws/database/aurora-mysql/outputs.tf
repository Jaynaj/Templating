output "cluster_id" {
  description = "Cluster ID"
  value       = aws_rds_cluster.this.id
}

output "cluster_arn" {
  description = "Cluster ARN"
  value       = aws_rds_cluster.this.arn
}

output "cluster_endpoint" {
  description = "Writer endpoint"
  value       = aws_rds_cluster.this.endpoint
}

output "cluster_reader_endpoint" {
  description = "Reader endpoint"
  value       = aws_rds_cluster.this.reader_endpoint
}

output "cluster_port" {
  description = "Cluster port"
  value       = aws_rds_cluster.this.port
}

output "cluster_database_name" {
  description = "Database name"
  value       = aws_rds_cluster.this.database_name
}

output "cluster_master_username" {
  description = "Master username"
  value       = aws_rds_cluster.this.master_username
  sensitive   = true
}

output "cluster_resource_id" {
  description = "Cluster resource ID"
  value       = aws_rds_cluster.this.cluster_resource_id
}

output "cluster_hosted_zone_id" {
  description = "Hosted zone ID"
  value       = aws_rds_cluster.this.hosted_zone_id
}

output "cluster_members" {
  description = "List of cluster members"
  value       = aws_rds_cluster.this.cluster_members
}

output "instance_ids" {
  description = "List of instance IDs"
  value       = aws_rds_cluster_instance.this[*].id
}

output "instance_arns" {
  description = "List of instance ARNs"
  value       = aws_rds_cluster_instance.this[*].arn
}

output "instance_endpoints" {
  description = "List of instance endpoints"
  value       = aws_rds_cluster_instance.this[*].endpoint
}

output "instance_availability_zones" {
  description = "List of instance availability zones"
  value       = aws_rds_cluster_instance.this[*].availability_zone
}

output "cluster_parameter_group_id" {
  description = "Cluster parameter group ID"
  value       = try(aws_rds_cluster_parameter_group.this[0].id, null)
}

output "db_parameter_group_id" {
  description = "Instance parameter group ID"
  value       = try(aws_db_parameter_group.this[0].id, null)
}

output "connection_string" {
  description = "MySQL connection string"
  value       = "mysql -h ${aws_rds_cluster.this.endpoint} -P ${aws_rds_cluster.this.port} -u ${aws_rds_cluster.this.master_username} -p"
  sensitive   = true
}
