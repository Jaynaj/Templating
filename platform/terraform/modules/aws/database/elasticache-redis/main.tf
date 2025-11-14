resource "aws_elasticache_cluster" "this" {
  # Configure your ElastiCache Redis cluster here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
