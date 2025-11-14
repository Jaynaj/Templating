# EFS Filesystem Module

Creates an AWS Elastic File System (EFS) with mount targets, access points, and lifecycle policies.

## Features

- **High Availability**: Multi-AZ mount targets for redundancy
- **Security**: Encryption at rest and in transit, security groups, IAM policies
- **Performance**: Configurable performance and throughput modes
- **Cost Optimization**: Lifecycle policies to transition to Infrequent Access (IA)
- **Access Control**: Access points with POSIX permissions
- **Backup**: Automatic backups with AWS Backup integration
- **Replication**: Cross-region replication for disaster recovery

## Usage

### Basic EFS File System

```hcl
module "efs" {
  source = "../../modules/aws/storage/efs-filesystem"

  name = "app-shared-storage"

  # Mount targets in private subnets (one per AZ)
  subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  security_group_ids = [aws_security_group.efs.id]

  # Cost optimization
  transition_to_ia = "AFTER_30_DAYS"

  # Security
  encrypted  = true
  kms_key_id = aws_kms_key.efs.arn

  tags = {
    Environment = "production"
    Purpose     = "shared-storage"
  }
}

# Security group for EFS
resource "aws_security_group" "efs" {
  name        = "efs-sg"
  description = "Security group for EFS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 2049
    to_port         = 2049
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Mount in EC2 user data
resource "aws_instance" "app" {
  # ... other config ...

  user_data = <<-EOF
    #!/bin/bash
    yum install -y amazon-efs-utils
    mkdir -p /mnt/efs
    mount -t efs -o tls ${module.efs.file_system_id}:/ /mnt/efs
    echo "${module.efs.file_system_id}:/ /mnt/efs efs _netdev,tls 0 0" >> /etc/fstab
  EOF
}
```

### EFS with Access Points

```hcl
module "efs" {
  source = "../../modules/aws/storage/efs-filesystem"

  name = "multi-tenant-storage"

  subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  security_group_ids = [aws_security_group.efs.id]

  # Create access points for different applications
  access_points = {
    app1 = {
      posix_user = {
        gid = 1001
        uid = 1001
      }
      root_directory = {
        path = "/app1"
        creation_info = {
          owner_gid   = 1001
          owner_uid   = 1001
          permissions = "755"
        }
      }
    }
    app2 = {
      posix_user = {
        gid = 1002
        uid = 1002
      }
      root_directory = {
        path = "/app2"
        creation_info = {
          owner_gid   = 1002
          owner_uid   = 1002
          permissions = "755"
        }
      }
    }
  }

  tags = {
    Environment = "production"
  }
}

# Mount access point in ECS task definition
resource "aws_ecs_task_definition" "app" {
  family = "app"

  volume {
    name = "efs-storage"

    efs_volume_configuration {
      file_system_id     = module.efs.file_system_id
      transit_encryption = "ENABLED"
      
      authorization_config {
        access_point_id = module.efs.access_point_ids["app1"]
        iam             = "ENABLED"
      }
    }
  }

  container_definitions = jsonencode([{
    name  = "app"
    image = "nginx"
    mountPoints = [{
      sourceVolume  = "efs-storage"
      containerPath = "/data"
    }]
  }])
}
```

### High-Performance EFS

```hcl
module "efs_high_perf" {
  source = "../../modules/aws/storage/efs-filesystem"

  name = "high-performance-storage"

  subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  security_group_ids = [aws_security_group.efs.id]

  # Max I/O for high throughput workloads
  performance_mode = "maxIO"

  # Elastic throughput scales automatically
  throughput_mode = "elastic"

  # Or use provisioned throughput for consistent performance
  # throughput_mode                 = "provisioned"
  # provisioned_throughput_in_mibps = 100

  # Skip IA transition for performance-critical data
  transition_to_ia = null

  tags = {
    Workload = "high-throughput"
  }
}
```

### EFS with Cross-Region Replication

```hcl
module "efs_primary" {
  source = "../../modules/aws/storage/efs-filesystem"

  name = "primary-storage"

  subnet_ids         = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  security_group_ids = [aws_security_group.efs.id]

  encrypted  = true
  kms_key_id = aws_kms_key.efs_primary.arn

  # Replicate to DR region
  replication_configuration = {
    region     = "us-west-2"
    kms_key_id = aws_kms_key.efs_dr.arn
  }

  tags = {
    Environment = "production"
    Region      = "primary"
  }
}
```

## Performance Modes

### General Purpose (Default)
- **Latency**: Lowest latency per operation
- **IOPS**: Up to 35,000 read IOPS or 7,000 write IOPS
- **Use case**: Most workloads, web serving, content management

### Max I/O
- **Latency**: Slightly higher latency
- **IOPS**: Virtually unlimited (> 500,000 IOPS)
- **Use case**: Big data, media processing, parallel workloads

## Throughput Modes

### Bursting (Default)
- Throughput scales with file system size
- 50 MiB/s per TiB of storage
- Burst to 100 MiB/s for short periods
- **Use case**: Variable workloads

### Provisioned
- Specify throughput independent of storage size
- Up to 1,024 MiB/s
- **Use case**: Consistent high throughput needs

### Elastic (Recommended for most)
- Automatically scales throughput up/down based on workload
- Up to 3 GiB/s for reads, 1 GiB/s for writes
- **Use case**: Unpredictable or spiky workloads

## Storage Classes

### Standard
- Frequently accessed files
- Multi-AZ durability
- Lowest latency

### Infrequent Access (IA)
- 92% lower cost than Standard
- Retrieval fee per GB
- Automatically managed by lifecycle policies

## Cost Optimization

Enable lifecycle management to save costs:

```hcl
# Files not accessed for 30 days move to IA
transition_to_ia = "AFTER_30_DAYS"

# Files accessed once return to Standard
transition_to_primary_storage_class = "AFTER_1_ACCESS"
```

Typical cost savings:
- Small files accessed frequently: Keep in Standard
- Large files accessed occasionally: Move to IA after 30 days (92% cheaper)

Example: 1 TB file system with 70% of files inactive
- Without lifecycle: $300/month
- With lifecycle: $110/month (63% savings)

## Access Patterns

### Pattern 1: Shared File System
```
EC2 Instance A ─┐
EC2 Instance B ─┼─→ EFS Mount Target A (AZ-A)
EC2 Instance C ─┤   EFS Mount Target B (AZ-B) ─→ EFS File System
ECS Task 1 ─────┤
ECS Task 2 ─────┘
```

### Pattern 2: Multi-Tenant with Access Points
```
App 1 → Access Point 1 → /app1 (UID 1001)
App 2 → Access Point 2 → /app2 (UID 1002) ─→ EFS File System
App 3 → Access Point 3 → /app3 (UID 1003)
```

## Mounting EFS

### NFSv4.1 (Standard)
```bash
sudo mount -t nfs4 -o nfsvers=4.1 ${file_system_id}.efs.${region}.amazonaws.com:/ /mnt/efs
```

### EFS Mount Helper (Recommended)
```bash
sudo yum install -y amazon-efs-utils
sudo mount -t efs -o tls ${file_system_id}:/ /mnt/efs
```

### EFS Mount Helper with Access Point
```bash
sudo mount -t efs -o tls,accesspoint=${access_point_id} ${file_system_id}:/ /mnt/efs
```

### /etc/fstab Entry
```
${file_system_id}:/ /mnt/efs efs _netdev,tls,iam 0 0
```

## Best Practices

1. **Always encrypt** at rest and in transit
2. **Use EFS mount helper** for automatic TLS encryption
3. **Create mount targets** in all AZs where you have resources
4. **Use access points** for multi-tenant applications
5. **Enable lifecycle management** to reduce costs
6. **Use elastic throughput** for most workloads
7. **Configure security groups** to allow NFS port 2049
8. **Enable automatic backups** with AWS Backup
9. **Use IAM authorization** with access points in ECS
10. **Monitor performance** with CloudWatch metrics

## Security Best Practices

1. **Encryption in transit**: Use TLS (`-o tls` mount option)
2. **Encryption at rest**: Always enable with KMS
3. **IAM policies**: Restrict access with file system policies
4. **Security groups**: Limit access to specific application SGs
5. **VPC only**: EFS is VPC-only, no public access
6. **Access points**: Enforce user identity with POSIX permissions

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |
