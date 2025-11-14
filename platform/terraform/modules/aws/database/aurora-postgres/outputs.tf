output "id" {
  description = "ID of the cluster"
  value       = aws_rds_cluster.this.id
}

output "arn" {
  description = "ARN of the cluster"
  value       = try(aws_rds_cluster.this.arn, null)
}
