# Aurora MySQL Module

Creates AWS Aurora MySQL clusters with support for provisioned, serverless v2, and auto-scaling configurations.

## Features

- **MySQL Compatibility**: Compatible with MySQL 5.7 and 8.0
- **High Availability**: Multi-AZ with automatic failover
- **Serverless v2**: Scale instantly from 0.5 to 128 ACUs
- **Auto-Scaling**: Automatic read replica scaling based on load
- **Backtrack**: Rewind database to any point (MySQL 5.7 compatible)
- **Global Database**: Multi-region replication
- **Performance**: Up to 5x faster than standard MySQL
- **Security**: Encryption, IAM authentication, network isolation

## Usage

### Basic Aurora MySQL Cluster

```hcl
module "aurora_mysql" {
  source = "../../modules/aws/database/aurora-mysql"

  cluster_identifier             = "app-mysql"
  engine_version                 = "8.0.mysql_aurora.3.04.0"
  db_cluster_parameter_group_family = "aurora-mysql8.0"
  db_parameter_group_family         = "aurora-mysql8.0"

  database_name    = "appdb"
  master_username  = "admin"
  master_password  = var.db_password

  instance_class = "db.r5.large"
  instance_count = 2

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.aurora.id]

  backup_retention_period = 7
  storage_encrypted       = true

  tags = {
    Environment = "production"
  }
}
```

### Serverless v2 Aurora MySQL

```hcl
module "aurora_serverless" {
  source = "../../modules/aws/database/aurora-mysql"

  cluster_identifier             = "serverless-mysql"
  engine_version                 = "8.0.mysql_aurora.3.04.0"
  db_cluster_parameter_group_family = "aurora-mysql8.0"
  db_parameter_group_family         = "aurora-mysql8.0"

  database_name    = "appdb"
  master_username  = "admin"
  master_password  = var.db_password

  # Serverless v2 configuration
  instance_class   = "db.serverless"
  instance_count   = 2

  serverlessv2_scaling_configuration = {
    min_capacity = 0.5   # 0.5 ACU (1 GB RAM)
    max_capacity = 16    # 16 ACU (32 GB RAM)
  }

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.aurora.id]

  backup_retention_period = 7
  storage_encrypted       = true

  tags = {
    Type = "serverless-v2"
  }
}
```

### Auto-Scaling Read Replicas

```hcl
module "aurora_autoscaling" {
  source = "../../modules/aws/database/aurora-mysql"

  cluster_identifier             = "autoscale-mysql"
  engine_version                 = "8.0.mysql_aurora.3.04.0"
  db_cluster_parameter_group_family = "aurora-mysql8.0"
  db_parameter_group_family         = "aurora-mysql8.0"

  database_name    = "appdb"
  master_username  = "admin"
  master_password  = var.db_password

  instance_class = "db.r5.xlarge"
  instance_count = 2  # Initial count

  # Enable auto-scaling
  enable_autoscaling          = true
  autoscaling_min_capacity    = 2
  autoscaling_max_capacity    = 5
  autoscaling_metric_type     = "RDSReaderAverageCPUUtilization"
  autoscaling_target_value    = 70
  autoscaling_scale_in_cooldown  = 300
  autoscaling_scale_out_cooldown = 300

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.aurora.id]

  tags = {
    Autoscaling = "enabled"
  }
}
```

### Aurora MySQL with Backtrack (5.7 only)

```hcl
module "aurora_backtrack" {
  source = "../../modules/aws/database/aurora-mysql"

  cluster_identifier             = "backtrack-mysql"
  engine_version                 = "5.7.mysql_aurora.2.11.3"
  db_cluster_parameter_group_family = "aurora-mysql5.7"
  db_parameter_group_family         = "aurora-mysql5.7"

  database_name    = "appdb"
  master_username  = "admin"
  master_password  = var.db_password

  instance_class = "db.r5.large"
  instance_count = 2

  # Enable backtrack (up to 72 hours)
  backtrack_window = 259200  # 72 hours in seconds

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.aurora.id]

  enabled_cloudwatch_logs_exports = ["audit", "error", "general", "slowquery"]

  tags = {
    Feature = "backtrack"
  }
}
```

### Aurora Global Database

```hcl
# Primary cluster in us-east-1
resource "aws_rds_global_cluster" "main" {
  global_cluster_identifier = "global-mysql"
  engine                    = "aurora-mysql"
  engine_version            = "8.0.mysql_aurora.3.04.0"
  database_name             = "appdb"
  storage_encrypted         = true
}

module "aurora_primary" {
  source = "../../modules/aws/database/aurora-mysql"

  cluster_identifier             = "global-mysql-primary"
  engine_version                 = "8.0.mysql_aurora.3.04.0"
  db_cluster_parameter_group_family = "aurora-mysql8.0"
  db_parameter_group_family         = "aurora-mysql8.0"

  master_username = "admin"
  master_password = var.db_password

  instance_class = "db.r5.xlarge"
  instance_count = 2

  global_cluster_identifier = aws_rds_global_cluster.main.id

  db_subnet_group_name   = aws_db_subnet_group.primary.name
  vpc_security_group_ids = [aws_security_group.aurora_primary.id]

  tags = {
    Region = "primary"
    GlobalCluster = "true"
  }
}

# Secondary cluster in eu-west-1
module "aurora_secondary" {
  source = "../../modules/aws/database/aurora-mysql"
  providers = {
    aws = aws.eu_west_1
  }

  cluster_identifier             = "global-mysql-secondary"
  engine_version                 = "8.0.mysql_aurora.3.04.0"
  db_cluster_parameter_group_family = "aurora-mysql8.0"
  db_parameter_group_family         = "aurora-mysql8.0"

  instance_class = "db.r5.xlarge"
  instance_count = 2

  global_cluster_identifier = aws_rds_global_cluster.main.id

  db_subnet_group_name   = aws_db_subnet_group.secondary.name
  vpc_security_group_ids = [aws_security_group.aurora_secondary.id]

  tags = {
    Region = "secondary"
    GlobalCluster = "true"
  }
}
```

## MySQL Versions

### MySQL 8.0 Compatible (Recommended)
- **Latest**: 8.0.mysql_aurora.3.04.0
- **Features**: JSON, CTEs, window functions, better performance
- **Use case**: New applications

### MySQL 5.7 Compatible
- **Latest**: 5.7.mysql_aurora.2.11.3
- **Features**: Backtrack support, JSON
- **Use case**: Legacy applications requiring 5.7 compatibility

## Instance Classes

### Burstable (T3/T4g)
- **db.t3.small** - **db.t3.large**: Dev/test
- **db.t4g.medium** - **db.t4g.large**: ARM-based, cost-effective dev/test

### Memory Optimized (R5/R6g)
- **db.r5.large** - **db.r5.24xlarge**: Production workloads
- **db.r6g.large** - **db.r6g.16xlarge**: ARM-based, better price/performance

### Serverless v2
- **db.serverless**: Automatic scaling from 0.5 to 128 ACUs
- **1 ACU** = 2 GB RAM + proportional CPU/network

## Common Cluster Parameters

```hcl
cluster_parameters = [
  {
    name  = "character_set_server"
    value = "utf8mb4"
  },
  {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  },
  {
    name  = "max_connections"
    value = "1000"
  },
  {
    name  = "slow_query_log"
    value = "1"
  },
  {
    name  = "long_query_time"
    value = "2"
  },
  {
    name  = "binlog_format"
    value = "ROW"
  }
]
```

## Common Instance Parameters

```hcl
instance_parameters = [
  {
    name  = "innodb_buffer_pool_size"
    value = "{DBInstanceClassMemory*3/4}"
  },
  {
    name  = "query_cache_type"
    value = "0"
  },
  {
    name  = "innodb_flush_log_at_trx_commit"
    value = "2"  # Better performance, slight risk
  }
]
```

## Backtrack vs. Backups

### Backtrack (MySQL 5.7 only)
- **Instant**: Rewind in seconds
- **Granular**: Any second within window (up to 72 hours)
- **In-place**: No restore needed
- **Use case**: Quick recovery from mistakes (wrong DELETE, schema changes)

### Backups (Both 5.7 and 8.0)
- **Point-in-time**: Any second within retention period (1-35 days)
- **Restore**: Creates new cluster
- **Use case**: Long-term recovery, compliance

## Performance Comparison

Aurora MySQL vs. Standard MySQL RDS:
- **Read**: 5x faster (up to 100k read IOPS)
- **Write**: 2x faster (up to 200k write IOPS)
- **Replica Lag**: < 100ms (vs. seconds for RDS)
- **Storage**: Auto-scales to 128 TB
- **Availability**: 99.99% SLA

## Cost Optimization

### Serverless v2
- **Best for**: Variable or unpredictable workloads
- **Savings**: 90% vs. provisioned for idle times
- **Example**: Dev/test databases (auto-pause)

### Aurora I/O-Optimized
- **Best for**: High I/O workloads
- **Pricing**: 40% higher instance cost, no I/O charges
- **Break-even**: > 25% of instance cost in I/O

### Reserved Instances
- **1 year**: 30% savings
- **3 years**: 60% savings
- **Best for**: Steady production workloads

### Right-Sizing
- Monitor CPU, memory, connections
- Start with smaller instances
- Use Performance Insights to identify bottlenecks

## Monitoring

Key metrics to monitor:
- **CPUUtilization**: CPU usage
- **DatabaseConnections**: Active connections
- **AuroraReplicaLag**: Replica lag in ms
- **CommitLatency**: Write latency
- **SelectLatency**: Read latency
- **FreeableMemory**: Available memory
- **VolumeReadIOPs/VolumeWriteIOPs**: IOPS utilization

## Best Practices

1. **Use Aurora MySQL 8.0** for new applications
2. **Enable encryption** at rest
3. **Use IAM authentication** for enhanced security
4. **Enable Performance Insights** for query analysis
5. **Set appropriate parameter groups** for your workload
6. **Use read endpoints** for read-only queries
7. **Enable auto-scaling** for variable workloads
8. **Monitor replica lag** and set alarms
9. **Use Serverless v2** for unpredictable workloads
10. **Regular backups** with 7+ day retention

## High Availability

Aurora provides:
- **Storage replication**: 6 copies across 3 AZs
- **Automatic failover**: 30 seconds or less
- **Read replicas**: Up to 15 replicas
- **Self-healing storage**: Continuous scanning and repair
- **Backup**: Continuous backup to S3

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |
