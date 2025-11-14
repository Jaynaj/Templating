# ElastiCache Redis Module

Creates AWS ElastiCache Redis clusters with support for cluster mode, encryption, backups, and high availability.

## Features

- **High Availability**: Multi-AZ with automatic failover
- **Scalability**: Cluster mode with sharding support
- **Security**: Encryption at rest and in transit, AUTH token, RBAC
- **Backups**: Automated backups with configurable retention
- **Monitoring**: CloudWatch metrics and logs
- **Performance**: Support for r6gd data tiering

## Usage

### Basic Redis Cluster

```hcl
module "redis" {
  source = "../../modules/aws/database/elasticache-redis"

  replication_group_id = "app-cache"
  description          = "Application cache"
  
  node_type          = "cache.r6g.large"
  num_cache_clusters = 3
  engine_version     = "7.0"

  security_group_ids = [aws_security_group.redis.id]
  subnet_group_name  = aws_elasticache_subnet_group.redis.name

  automatic_failover_enabled = true
  multi_az_enabled           = true

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token_enabled         = true
  auth_token                 = var.redis_password

  snapshot_retention_limit = 7

  tags = {
    Environment = "production"
  }
}
```

### Cluster Mode (Sharded)

```hcl
module "redis_cluster" {
  source = "../../modules/aws/database/elasticache-redis"

  replication_group_id = "app-cache-sharded"
  node_type            = "cache.r6g.xlarge"
  engine_version       = "7.0"

  cluster_mode_enabled = true
  cluster_mode = {
    num_node_groups         = 3  # 3 shards
    replicas_per_node_group = 2  # 2 replicas per shard
  }

  security_group_ids = [aws_security_group.redis.id]
  subnet_group_name  = aws_elasticache_subnet_group.redis.name

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = var.redis_password

  tags = {
    Environment = "production"
    Mode        = "cluster"
  }
}
```

## Redis Versions

- **7.0** (recommended): Latest features
- **6.2**: Long-term support
- **6.0**: Legacy support

## Node Types

### Memory Optimized (R6g - Graviton2)
- **cache.r6g.large** - cache.r6g.16xlarge
- Best price/performance
- ARM-based

### Memory Optimized with NVMe (R6gd)
- **cache.r6gd.xlarge** - cache.r6gd.16xlarge
- Data tiering for cost optimization
- NVMe SSD for warm data

### Memory Optimized (R5)
- **cache.r5.large** - cache.r5.24xlarge
- Previous generation

### Compute Optimized (M6g)
- **cache.m6g.large** - cache.m6g.16xlarge
- Balanced compute/memory

### Burstable (T3/T4g)
- **cache.t3.micro** - cache.t3.medium
- **cache.t4g.micro** - cache.t4g.medium
- Dev/test only

## Cluster Modes

### Non-Cluster Mode
- Single shard
- Up to 5 replicas
- Simpler setup
- Max 250GB data

### Cluster Mode (Sharding)
- Multiple shards (up to 500)
- Horizontal scaling
- Better performance for large datasets
- Required for > 250GB

## Best Practices

1. **Enable encryption** at rest and in transit
2. **Use AUTH token** for authentication
3. **Enable Multi-AZ** for production
4. **Use r6g nodes** for best performance/cost
5. **Set appropriate backup retention** (3-7 days)
6. **Use cluster mode** for datasets > 250GB
7. **Configure proper security groups**
8. **Monitor memory usage** and eviction metrics
9. **Use connection pooling** in applications
10. **Test failover procedures**

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |
