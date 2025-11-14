# Aurora PostgreSQL Module

Creates AWS Aurora PostgreSQL clusters with support for provisioned, serverless v1/v2, global databases, and auto-scaling.

## Features

- **High Availability**: Multi-AZ cluster with automatic failover
- **Performance**: Up to 3x throughput of standard PostgreSQL
- **Scalability**: Auto-scaling read replicas, serverless options
- **Backup**: Continuous backups, point-in-time recovery, backtrack
- **Security**: Encryption at rest/transit, IAM authentication
- **Monitoring**: Performance Insights, Enhanced Monitoring, CloudWatch Logs
- **Global**: Multi-region replication support

## Usage

### Provisioned Aurora Cluster

```hcl
module "aurora_postgres" {
  source = "../../modules/aws/database/aurora-postgres"

  cluster_identifier = "production-aurora"
  engine_version     = "15.4"
  engine_mode        = "provisioned"

  database_name   = "myapp"
  master_username = "postgres"
  master_password = var.db_password

  instance_count = 3
  instance_class = "db.r6g.xlarge"

  vpc_security_group_ids = [aws_security_group.aurora.id]
  db_subnet_group_name   = aws_db_subnet_group.aurora.name

  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds.arn

  backup_retention_period = 14
  backtrack_window        = 86400  # 24 hours

  iam_database_authentication_enabled = true

  performance_insights_enabled = true
  monitoring_interval          = 60

  deletion_protection = true

  tags = {
    Environment = "production"
  }
}
```

### Serverless v2 (Recommended for Variable Workloads)

```hcl
module "aurora_serverless_v2" {
  source = "../../modules/aws/database/aurora-postgres"

  cluster_identifier = "app-serverless"
  engine_version     = "15.4"
  engine_mode        = "provisioned"  # Serverless v2 uses provisioned mode

  database_name   = "myapp"
  master_username = "postgres"
  master_password = var.db_password

  instance_count = 2
  instance_class = "db.serverless"  # Serverless v2 instance class

  serverlessv2_scaling_configuration = {
    min_capacity = 0.5  # 0.5 ACU minimum
    max_capacity = 16   # 16 ACU maximum
  }

  vpc_security_group_ids = [aws_security_group.aurora.id]
  db_subnet_group_name   = aws_db_subnet_group.aurora.name

  tags = {
    Environment = "development"
    Type        = "serverless-v2"
  }
}
```

### With Auto-Scaling Read Replicas

```hcl
module "aurora_autoscaling" {
  source = "../../modules/aws/database/aurora-postgres"

  cluster_identifier = "production-aurora"
  engine_version     = "15.4"

  master_username = "postgres"
  master_password = var.db_password

  instance_count = 2
  instance_class = "db.r6g.large"

  vpc_security_group_ids = [aws_security_group.aurora.id]
  db_subnet_group_name   = aws_db_subnet_group.aurora.name

  # Auto-scaling configuration
  enable_autoscaling        = true
  autoscaling_min_capacity  = 2
  autoscaling_max_capacity  = 10
  autoscaling_target_cpu    = 70

  tags = {
    Environment = "production"
    AutoScaling = "enabled"
  }
}
```

## Aurora PostgreSQL Versions

Supported versions:
- **15.x** (recommended): 15.4, 15.3
- **14.x**: 14.9, 14.8, 14.7
- **13.x**: 13.12, 13.11
- **12.x**: 12.16, 12.15
- **11.x**: 11.21 (legacy)

## Instance Classes

### Serverless v2 (Recommended for Variable Loads)
- **db.serverless**: 0.5 to 128 ACUs
- ACU = Aurora Capacity Unit (2 GB RAM, CPU, networking)
- Scales in 0.5 ACU increments
- Best for: Variable, intermittent, or unpredictable workloads

### Memory Optimized (R6g - Graviton2)
- **db.r6g.large** - db.r6g.16xlarge
- ARM-based, best price/performance
- 2:1 memory to CPU ratio
- Recommended for production

### Memory Optimized (R6i/R5)
- **db.r6i.large** - db.r6i.32xlarge: Intel-based
- **db.r5.large** - db.r5.24xlarge: Previous generation

### Burstable (T3/T4g)
- **db.t3.medium** - db.t3.large
- **db.t4g.medium** - db.t4g.large: ARM-based
- Good for dev/test, not production

## Engine Modes

### Provisioned (Recommended)
- Traditional Aurora instances
- Supports Serverless v2 scaling
- Best for most workloads

### Serverless v1 (Legacy)
- Auto-scales compute capacity
- Less flexible than v2
- Being superseded by Serverless v2

## Features

### Backtrack
- Rewind database to previous point in time
- Up to 72 hours
- Only for MySQL-compatible (not PostgreSQL)

### Global Database
- Multi-region replication
- < 1 second replication lag
- Fast regional failover

### Data API
- HTTP endpoint for queries
- No persistent connections
- Good for serverless apps

## Auto-Scaling

Auto-scaling adds/removes read replicas based on:
- CPU utilization
- Database connections
- Custom CloudWatch metrics

Benefits:
- Handle traffic spikes automatically
- Cost optimization during low traffic
- Better read performance

## Best Practices

1. **Use Serverless v2** for variable workloads
2. **Enable backtrack** for quick recovery (MySQL only)
3. **Use r6g instances** for best price/performance
4. **Enable encryption** with customer-managed keys
5. **Set appropriate backup retention** (7-35 days)
6. **Use IAM authentication** for enhanced security
7. **Enable Performance Insights** for troubleshooting
8. **Configure auto-scaling** for read replicas
9. **Use cluster endpoint** for writes
10. **Use reader endpoint** for reads

## Cost Optimization

1. Use **Serverless v2** for non-24/7 workloads
2. Use **r6g instances** (20% cheaper than r5)
3. Right-size instances based on metrics
4. Use **Reserved Instances** for predictable loads
5. Set appropriate backup retention

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_identifier | Cluster identifier | `string` | n/a | yes |
| master_username | Master username | `string` | n/a | yes |
| master_password | Master password | `string` | n/a | yes |
| vpc_security_group_ids | Security groups | `list(string)` | n/a | yes |
| db_subnet_group_name | Subnet group | `string` | n/a | yes |
| instance_count | Number of instances | `number` | `2` | no |
| instance_class | Instance class | `string` | `"db.r6g.large"` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster_endpoint | Writer endpoint |
| cluster_reader_endpoint | Reader endpoint |
| cluster_port | Database port |
| instance_endpoints | Individual instance endpoints |
