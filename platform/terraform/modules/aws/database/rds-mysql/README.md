# RDS MySQL Module

Creates AWS RDS MySQL database instances with comprehensive features including Multi-AZ, backups, encryption, monitoring, and read replicas.

## Features

- **High Availability**: Multi-AZ deployment for automatic failover
- **Backup & Recovery**: Automated backups with configurable retention, point-in-time recovery
- **Security**: Encryption at rest with KMS, IAM database authentication
- **Monitoring**: Enhanced monitoring, Performance Insights, CloudWatch Logs
- **Scalability**: Read replicas for read-heavy workloads
- **Performance**: GP3 storage with configurable IOPS and throughput
- **Maintenance**: Automated minor version upgrades, configurable maintenance windows

## Usage

### Basic MySQL Instance

```hcl
module "mysql_db" {
  source = "../../modules/aws/database/rds-mysql"

  identifier     = "production-mysql"
  engine_version = "8.0.35"
  instance_class = "db.t3.medium"

  allocated_storage = 100
  storage_type      = "gp3"
  storage_encrypted = true
  kms_key_id        = aws_kms_key.rds.arn

  db_name  = "myapp"
  username = "admin"
  password = var.db_password  # Use AWS Secrets Manager in production

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  multi_az            = true
  deletion_protection = true

  backup_retention_period = 7
  backup_window           = "03:00-04:00"
  maintenance_window      = "sun:04:00-sun:05:00"

  enabled_cloudwatch_logs_exports = ["error", "general", "slowquery"]

  performance_insights_enabled = true
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.rds_monitoring.arn

  tags = {
    Environment = "production"
    Application = "myapp"
  }
}
```

### With Read Replicas

```hcl
module "mysql_db_with_replicas" {
  source = "../../modules/aws/database/rds-mysql"

  identifier     = "production-mysql"
  engine_version = "8.0.35"
  instance_class = "db.r6g.xlarge"

  allocated_storage = 500
  storage_type      = "gp3"
  iops              = 12000
  storage_throughput = 500

  db_name  = "myapp"
  username = "admin"
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  multi_az = true

  # Read replicas for scaling reads
  create_read_replica       = true
  read_replica_count        = 2
  replica_instance_class    = "db.r6g.large"
  replica_availability_zones = ["us-east-1b", "us-east-1c"]

  performance_insights_enabled = true

  tags = {
    Environment = "production"
    HighVolume  = "true"
  }
}
```

### Point-in-Time Recovery

```hcl
module "mysql_restored" {
  source = "../../modules/aws/database/rds-mysql"

  identifier     = "restored-mysql"
  instance_class = "db.t3.medium"

  restore_to_point_in_time = {
    source_db_instance_identifier = "production-mysql"
    use_latest_restorable_time    = true
  }

  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name

  tags = {
    Environment = "recovery"
  }
}
```

## MySQL Version Support

Supported versions:
- MySQL 8.0 (recommended): 8.0.35, 8.0.33, 8.0.32
- MySQL 5.7 (legacy): 5.7.44, 5.7.42

## Instance Classes

### General Purpose (T3/T4g)
- **db.t3.micro** - db.t3.2xlarge: Burstable performance
- **db.t4g.micro** - db.t4g.2xlarge: ARM-based Graviton2 (20% better price/performance)

### Memory Optimized (R6g/R6i/R5)
- **db.r6g.large** - db.r6g.16xlarge: ARM-based Graviton2, best for production
- **db.r6i.large** - db.r6i.32xlarge: Intel-based, high memory
- **db.r5.large** - db.r5.24xlarge: Previous generation

### Compute Optimized (C6g)
- **db.c6g.large** - db.c6g.16xlarge: High compute, lower memory

## Storage Options

### GP3 (Recommended)
- Baseline: 3,000 IOPS, 125 MB/s throughput
- Scalable: Up to 16,000 IOPS, 1,000 MB/s
- Cost-effective for most workloads

### GP2 (Legacy)
- IOPS scale with storage size
- 3 IOPS per GB, up to 16,000 IOPS

### IO1/IO2 (High Performance)
- For I/O intensive workloads
- Up to 64,000 IOPS
- Higher cost

## Monitoring

### CloudWatch Logs
- **error**: Error log
- **general**: General query log (high overhead)
- **slowquery**: Slow query log (recommended)

### Performance Insights
- Real-time database performance monitoring
- 7-day free retention
- Extended retention available

### Enhanced Monitoring
- OS-level metrics
- 60-second granularity recommended

## Best Practices

1. **Enable Multi-AZ** for production databases
2. **Use GP3 storage** for better cost/performance
3. **Enable encryption** with customer-managed KMS keys
4. **Configure automated backups** with 7+ day retention
5. **Enable Performance Insights** for troubleshooting
6. **Use read replicas** for read-heavy workloads
7. **Set deletion protection** for production databases
8. **Use parameter groups** for MySQL configuration
9. **Monitor slow queries** with CloudWatch Logs
10. **Test restore procedures** regularly

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| identifier | DB instance identifier | `string` | n/a | yes |
| instance_class | Instance class | `string` | n/a | yes |
| username | Master username | `string` | n/a | yes |
| password | Master password | `string` | n/a | yes |
| vpc_security_group_ids | Security group IDs | `list(string)` | n/a | yes |
| db_subnet_group_name | DB subnet group | `string` | n/a | yes |
| engine_version | MySQL version | `string` | `"8.0.35"` | no |
| allocated_storage | Storage in GB | `number` | `20` | no |
| multi_az | Enable Multi-AZ | `bool` | `true` | no |
| backup_retention_period | Backup retention days | `number` | `7` | no |

## Outputs

| Name | Description |
|------|-------------|
| db_instance_endpoint | Connection endpoint |
| db_instance_address | Database address |
| db_instance_port | Database port |
| replica_endpoints | Read replica endpoints |
