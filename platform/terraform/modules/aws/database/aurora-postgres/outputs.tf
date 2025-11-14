output "cluster_id" {
  description = "Aurora cluster ID"
  value       = aws_rds_cluster.this.id
}

output "cluster_arn" {
  description = "Aurora cluster ARN"
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

output "cluster_resource_id" {
  description = "Cluster resource ID"
  value       = aws_rds_cluster.this.cluster_resource_id
}

output "instance_endpoints" {
  description = "Instance endpoints"
  value       = aws_rds_cluster_instance.this[*].endpoint
}

output "instance_ids" {
  description = "Instance IDs"
  value       = aws_rds_cluster_instance.this[*].id
}
