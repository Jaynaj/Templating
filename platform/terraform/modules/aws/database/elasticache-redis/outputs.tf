output "id" {
  description = "ID of the cluster"
  value       = aws_elasticache_cluster.this.id
}

output "arn" {
  description = "ARN of the cluster"
  value       = try(aws_elasticache_cluster.this.arn, null)
}
