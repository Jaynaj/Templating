# RDS Oracle Module

Creates AWS RDS Oracle database instances with support for multiple editions, licensing models, and enterprise features.

## Features

- **Multiple Editions**: Standard Edition 2 (SE2) and Enterprise Edition (EE)
- **Licensing**: BYOL or License Included
- **CDB Support**: Multitenant Container Database architecture  
- **High Availability**: Multi-AZ deployments with automatic failover
- **Security**: Encryption at rest and in transit, network isolation
- **Monitoring**: Performance Insights, Enhanced Monitoring, CloudWatch Logs
- **Backup**: Automated backups with point-in-time recovery
- **Read Replicas**: Scale read workloads

## Usage

### Basic Oracle SE2 Database

```hcl
module "oracle_db" {
  source = "../../modules/aws/database/rds-oracle"

  identifier            = "prod-oracle"
  engine_edition        = "se2"
  engine_version        = "19.0.0.0.ru-2023-04.rur-2023-04.r1"
  major_engine_version  = "19"
  parameter_group_family = "oracle-se2-19"
  license_model         = "license-included"

  instance_class    = "db.t3.medium"
  allocated_storage = 100
  storage_type      = "gp3"
  storage_encrypted = true

  db_name         = "PROD"
  master_username = "admin"
  master_password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.oracle.id]

  multi_az                = true
  backup_retention_period = 7

  tags = {
    Environment = "production"
  }
}
```

### Oracle Enterprise Edition with Advanced Features

```hcl
module "oracle_ee" {
  source = "../../modules/aws/database/rds-oracle"

  identifier             = "enterprise-oracle"
  engine_edition         = "ee"
  engine_version         = "19.0.0.0.ru-2023-04.rur-2023-04.r1"
  major_engine_version   = "19"
  parameter_group_family = "oracle-ee-19"
  license_model          = "bring-your-own-license"

  instance_class    = "db.r5.2xlarge"
  allocated_storage = 1000
  storage_type      = "io1"
  iops              = 10000

  db_name         = "PROD"
  master_username = "admin"
  master_password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.oracle.id]

  multi_az                = true
  backup_retention_period = 30

  # Performance Insights
  performance_insights_enabled          = true
  performance_insights_retention_period = 731  # 2 years

  # Enhanced Monitoring
  monitoring_interval = 1  # 1 second granularity
  monitoring_role_arn = aws_iam_role.rds_monitoring.arn

  # CloudWatch Logs
  enabled_cloudwatch_logs_exports = ["alert", "audit", "trace", "listener"]

  # Oracle options (e.g., TDE, APEX, OEM)
  options = [
    {
      option_name = "TDE"
    },
    {
      option_name = "APEX"
      version     = "21.1.v1"
      port        = 8080
    },
    {
      option_name = "OEM"
      port        = 1158
      option_settings = [
        {
          name  = "OMS_PORT"
          value = "1158"
        }
      ]
    }
  ]

  # Custom parameters
  parameters = [
    {
      name  = "open_cursors"
      value = "2000"
    },
    {
      name  = "processes"
      value = "500"
    },
    {
      name  = "sessions"
      value = "1000"
    }
  ]

  deletion_protection = true

  tags = {
    Environment = "production"
    Criticality = "high"
  }
}
```

### Oracle CDB (Container Database)

```hcl
module "oracle_cdb" {
  source = "../../modules/aws/database/rds-oracle"

  identifier             = "oracle-cdb"
  engine_edition         = "ee-cdb"  # Container Database
  engine_version         = "19.0.0.0.ru-2023-04.rur-2023-04.r1"
  major_engine_version   = "19"
  parameter_group_family = "oracle-ee-cdb-19"
  license_model          = "bring-your-own-license"

  instance_class    = "db.m5.xlarge"
  allocated_storage = 200

  db_name         = "PDB1"  # Pluggable Database name
  master_username = "admin"
  master_password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.oracle.id]

  multi_az = true

  tags = {
    Architecture = "multitenant"
  }
}
```

### Oracle with Read Replicas

```hcl
module "oracle_with_replicas" {
  source = "../../modules/aws/database/rds-oracle"

  identifier            = "oracle-primary"
  engine_edition        = "se2"
  engine_version        = "19.0.0.0.0"
  major_engine_version  = "19"
  parameter_group_family = "oracle-se2-19"

  instance_class    = "db.m5.large"
  allocated_storage = 200

  db_name         = "PROD"
  master_username = "admin"
  master_password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.oracle.id]

  multi_az = true

  # Create read replicas
  create_read_replica = true
  read_replica_count  = 2

  replica_availability_zones = [
    "us-east-1b",
    "us-east-1c"
  ]

  tags = {
    Environment = "production"
  }
}
```

## Oracle Editions

### Standard Edition 2 (SE2)
- **Licensing**: License Included or BYOL
- **Max vCPU**: 4 vCPUs
- **Features**: Basic Oracle features, RAC not supported on RDS
- **Use case**: Small to medium workloads
- **Cost**: Lower licensing costs

### Enterprise Edition (EE)
- **Licensing**: BYOL only
- **Features**: All Oracle EE features including:
  - Partitioning
  - Advanced Compression
  - Advanced Security (TDE, Data Redaction)
  - Diagnostics Pack
  - Tuning Pack
  - Real Application Testing
- **Use case**: Mission-critical workloads requiring advanced features
- **Cost**: Higher licensing costs

### Container Database (CDB)
- **Architecture**: Oracle 12c+ Multitenant
- **Benefits**: Multiple pluggable databases (PDBs) in one container
- **Editions**: ee-cdb, se2-cdb
- **Use case**: Consolidating multiple databases

## License Models

### License Included
- AWS includes Oracle license
- Pay hourly
- Only available for SE2
- No upfront licensing costs
- Higher hourly costs

### Bring Your Own License (BYOL)
- Use existing Oracle licenses
- Available for SE2 and EE
- Lower hourly costs
- Requires valid Oracle license

## Oracle Versions

- **19c (19.0.0.0)**: Long-term release, recommended
- **21c (21.0.0.0)**: Innovation release
- **12c (12.2.0.1)**: Legacy support

## Common Option Group Options

### Transparent Data Encryption (TDE)
```hcl
options = [
  {
    option_name = "TDE"
  }
]
```

### Oracle Application Express (APEX)
```hcl
options = [
  {
    option_name = "APEX"
    version     = "21.1.v1"
    port        = 8080
  }
]
```

### Oracle Enterprise Manager (OEM)
```hcl
options = [
  {
    option_name = "OEM"
    port        = 1158
    option_settings = [
      {
        name  = "OMS_PORT"
        value = "1158"
      }
    ]
  }
]
```

### Oracle Spatial
```hcl
options = [
  {
    option_name = "SPATIAL"
  }
]
```

### Oracle OLAP
```hcl
options = [
  {
    option_name = "OLAP"
  }
]
```

## Common Parameters

### Memory and Process Configuration
```hcl
parameters = [
  {
    name  = "processes"
    value = "500"
  },
  {
    name  = "sessions"
    value = "1000"
  },
  {
    name  = "open_cursors"
    value = "2000"
  }
]
```

### Performance Tuning
```hcl
parameters = [
  {
    name  = "sga_target"
    value = "{DBInstanceClassMemory*3/4}"
  },
  {
    name  = "pga_aggregate_target"
    value = "{DBInstanceClassMemory/8}"
  }
]
```

## Character Sets

### Recommended Character Sets
- **AL32UTF8**: Unicode, supports all languages (recommended)
- **WE8ISO8859P1**: Western European
- **WE8MSWIN1252**: Windows Western European

### National Character Set
- **AL16UTF16**: Unicode (recommended)
- **UTF8**: Legacy Unicode

## Instance Class Recommendations

### Development/Test
- **db.t3.medium**: 2 vCPU, 4 GB RAM
- **db.t3.large**: 2 vCPU, 8 GB RAM

### Production (SE2)
- **db.m5.large**: 2 vCPU, 8 GB RAM
- **db.m5.xlarge**: 4 vCPU, 16 GB RAM (SE2 max)

### Production (EE)
- **db.r5.2xlarge**: 8 vCPU, 64 GB RAM
- **db.r5.4xlarge**: 16 vCPU, 128 GB RAM
- **db.r5.8xlarge**: 32 vCPU, 256 GB RAM

## Storage Types

### gp3 (General Purpose SSD) - Recommended
- **IOPS**: 3,000-16,000 baseline
- **Throughput**: 125-1,000 MB/s
- **Cost**: Best price/performance

### gp2 (General Purpose SSD)
- **IOPS**: Scales with size (3 IOPS/GB)
- **Use case**: Legacy, use gp3 instead

### io1/io2 (Provisioned IOPS)
- **IOPS**: Up to 64,000 (io2) or 256,000 (io2 Block Express)
- **Use case**: I/O intensive workloads

## Best Practices

1. **Always enable encryption** at rest and in transit
2. **Use Multi-AZ** for production databases
3. **Enable automatic backups** with 7+ day retention
4. **Enable Performance Insights** for query analysis
5. **Use parameter groups** to tune Oracle settings
6. **Enable deletion protection** for production
7. **Use read replicas** for read-heavy workloads
8. **Monitor key metrics**: CPU, connections, storage, IOPS
9. **Set appropriate instance class** based on workload
10. **Use VPC** with private subnets for security

## Cost Optimization

1. **Choose the right edition**: SE2 for most workloads
2. **Use License Included** for SE2 if no existing licenses
3. **Right-size instances**: Monitor and adjust as needed
4. **Use gp3 storage**: Better performance at lower cost
5. **Snapshot management**: Delete old manual snapshots
6. **Reserved Instances**: 30-60% savings for steady workloads
7. **Stop/start** for dev/test databases

## Monitoring

Key metrics to monitor:
- **CPUUtilization**: CPU usage
- **DatabaseConnections**: Active connections
- **FreeableMemory**: Available memory
- **FreeStorageSpace**: Available storage
- **ReadLatency/WriteLatency**: I/O performance
- **ReadIOPS/WriteIOPS**: IOPS utilization

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |
