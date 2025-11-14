output "replication_group_id" {
  description = "Replication group ID"
  value       = aws_elasticache_replication_group.this.id
}

output "replication_group_arn" {
  description = "Replication group ARN"
  value       = aws_elasticache_replication_group.this.arn
}

output "primary_endpoint_address" {
  description = "Primary endpoint address"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "reader_endpoint_address" {
  description = "Reader endpoint address"
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "configuration_endpoint_address" {
  description = "Configuration endpoint address (cluster mode)"
  value       = aws_elasticache_replication_group.this.configuration_endpoint_address
}

output "member_clusters" {
  description = "Member cluster IDs"
  value       = aws_elasticache_replication_group.this.member_clusters
}
