# FSx Filesystem Module

Creates AWS FSx file systems with support for Lustre, Windows File Server, NetApp ONTAP, and OpenZFS.

## Features

- **Multiple File Systems**: Lustre, Windows, ONTAP, OpenZFS
- **High Performance**: Sub-millisecond latencies, GB/s throughput
- **Enterprise Features**: AD integration, snapshots, replication
- **Security**: Encryption at rest and in transit, VPC isolation
- **Backup**: Automatic backups with configurable retention
- **S3 Integration**: Lustre integration with S3 for data lakes

## FSx Types Comparison

| Feature | Lustre | Windows | ONTAP | OpenZFS |
|---------|--------|---------|-------|---------|
| **Protocol** | Lustre | SMB | NFS, SMB, iSCSI | NFS |
| **Use Case** | HPC, ML | Windows apps | Multi-protocol | Linux workloads |
| **Performance** | Up to 1+ TB/s | Up to 2 GB/s | Up to 2 GB/s | Up to 4 GB/s |
| **IOPS** | Millions | 100k+ | 160k+ | 160k+ |
| **S3 Integration** | Yes | No | Yes | No |
| **AD Integration** | No | Yes | Yes | No |
| **Snapshots** | No | Yes | Yes | Yes |

## Usage

### FSx for Lustre (High-Performance Computing)

```hcl
module "fsx_lustre" {
  source = "../../modules/aws/storage/fsx-filesystem"

  name               = "ml-training-storage"
  file_system_type   = "LUSTRE"
  storage_capacity   = 1200  # GiB (increments of 1200)
  subnet_ids         = [aws_subnet.private_a.id]
  security_group_ids = [aws_security_group.fsx.id]

  # High performance persistent storage
  lustre_deployment_type      = "PERSISTENT_2"
  per_unit_storage_throughput = 500  # MB/s/TiB (125, 250, 500, 1000)
  
  # Data compression
  data_compression_type = "LZ4"

  # S3 integration for data lake
  import_path            = "s3://my-data-lake/input"
  export_path            = "s3://my-data-lake/output"
  auto_import_policy     = "NEW_CHANGED"

  tags = {
    Workload = "machine-learning"
  }
}

# Mount in EC2 for ML training
resource "aws_instance" "ml_worker" {
  # ... other config ...

  user_data = <<-EOF
    #!/bin/bash
    amazon-linux-extras install -y lustre2.10
    mkdir -p /mnt/fsx
    mount -t lustre ${module.fsx_lustre.lustre_dns_name}@tcp:/${module.fsx_lustre.lustre_mount_name} /mnt/fsx
  EOF
}
```

### FSx for Windows File Server

```hcl
# Managed Active Directory
resource "aws_directory_service_directory" "main" {
  name     = "corp.example.com"
  password = var.ad_password
  type     = "MicrosoftAD"
  edition  = "Standard"

  vpc_settings {
    vpc_id     = aws_vpc.main.id
    subnet_ids = [aws_subnet.private_a.id, aws_subnet.private_b.id]
  }
}

module "fsx_windows" {
  source = "../../modules/aws/storage/fsx-filesystem"

  name               = "file-server"
  file_system_type   = "WINDOWS"
  storage_capacity   = 32  # GiB (minimum 32 for SSD)
  subnet_ids         = [aws_subnet.private_a.id]
  security_group_ids = [aws_security_group.fsx.id]

  # Multi-AZ for high availability
  windows_deployment_type = "MULTI_AZ_1"
  preferred_subnet_id     = aws_subnet.private_a.id
  throughput_capacity     = 16  # MB/s (8, 16, 32, 64, 128, 256, 512, 1024, 2048)

  # Active Directory
  active_directory_id = aws_directory_service_directory.main.id

  # Backups
  automatic_backup_retention_days   = 14
  daily_automatic_backup_start_time = "03:00"

  # Audit logging
  audit_log_configuration = {
    file_access_audit_log_level       = "SUCCESS_AND_FAILURE"
    file_share_access_audit_log_level = "SUCCESS_AND_FAILURE"
    audit_log_destination             = "arn:aws:logs:us-east-1:123456789012:log-group:/aws/fsx/windows"
  }

  tags = {
    Environment = "production"
  }
}

# Mount in Windows EC2
resource "aws_instance" "windows" {
  ami           = "ami-xxxxx"  # Windows Server AMI
  instance_type = "t3.medium"

  user_data = <<-EOF
    <powershell>
    net use Z: \\${module.fsx_windows.windows_dns_name}\share /persistent:yes
    </powershell>
  EOF
}
```

### FSx for NetApp ONTAP (Multi-Protocol)

```hcl
module "fsx_ontap" {
  source = "../../modules/aws/storage/fsx-filesystem"

  name               = "enterprise-storage"
  file_system_type   = "ONTAP"
  storage_capacity   = 1024  # GiB (minimum 1024)
  subnet_ids         = [aws_subnet.private_a.id]
  security_group_ids = [aws_security_group.fsx.id]

  # Multi-AZ for HA
  ontap_deployment_type = "MULTI_AZ_1"
  preferred_subnet_id   = aws_subnet.private_a.id
  throughput_capacity   = 128  # MB/s

  # Floating IP range for cluster endpoints
  endpoint_ip_address_range = "198.19.255.0/24"
  route_table_ids           = [aws_route_table.private.id]

  # Admin password
  fsx_admin_password = var.fsx_admin_password

  # High IOPS
  disk_iops_configuration = {
    mode = "USER_PROVISIONED"
    iops = 96000
  }

  tags = {
    Purpose = "multi-protocol-storage"
  }
}

# Create ONTAP volume after file system
resource "aws_fsx_ontap_storage_virtual_machine" "main" {
  file_system_id = module.fsx_ontap.ontap_file_system_id
  name           = "svm1"
}

resource "aws_fsx_ontap_volume" "main" {
  name                       = "vol1"
  junction_path              = "/vol1"
  size_in_megabytes          = 1024000
  storage_virtual_machine_id = aws_fsx_ontap_storage_virtual_machine.main.id
  storage_efficiency_enabled = true
}
```

### FSx for OpenZFS (Linux Workloads)

```hcl
module "fsx_openzfs" {
  source = "../../modules/aws/storage/fsx-filesystem"

  name               = "app-storage"
  file_system_type   = "OPENZFS"
  storage_capacity   = 64   # GiB (minimum 64)
  subnet_ids         = [aws_subnet.private_a.id]
  security_group_ids = [aws_security_group.fsx.id]

  openzfs_deployment_type = "SINGLE_AZ_1"
  throughput_capacity     = 64  # MB/s (64, 128, 256, 512, 1024, 2048, 3072, 4096)

  # Root volume configuration
  root_volume_configuration = {
    data_compression_type  = "ZSTD"
    copy_tags_to_snapshots = true
    
    nfs_exports = {
      client_configurations = [
        {
          clients = ["*"]
          options = ["rw", "crossmnt", "no_root_squash"]
        }
      ]
    }
    
    user_and_group_quotas = [
      {
        id                         = 1001
        storage_capacity_quota_gib = 100
        type                       = "USER"
      }
    ]
  }

  # Automatic IOPS scaling
  disk_iops_configuration = {
    mode = "AUTOMATIC"
  }

  tags = {
    FileSystem = "zfs"
  }
}

# Mount in Linux EC2
resource "aws_instance" "app" {
  # ... other config ...

  user_data = <<-EOF
    #!/bin/bash
    yum install -y nfs-utils
    mkdir -p /mnt/fsx
    mount -t nfs -o nfsvers=3 ${module.fsx_openzfs.openzfs_dns_name}:/fsx /mnt/fsx
    echo "${module.fsx_openzfs.openzfs_dns_name}:/fsx /mnt/fsx nfs nfsvers=3,defaults 0 0" >> /etc/fstab
  EOF
}
```

## Lustre Deployment Types

### SCRATCH_1
- **Cost**: Lowest
- **Durability**: No replication
- **Throughput**: 200 MB/s/TiB
- **Use case**: Temporary storage, processing pipelines

### SCRATCH_2
- **Cost**: Low
- **Durability**: No replication
- **Throughput**: 200 MB/s/TiB
- **Burst**: Up to 1,300 MB/s/TiB
- **Use case**: Short-term processing with burst needs

### PERSISTENT_1
- **Durability**: Replicated within AZ
- **Throughput**: 50, 100, 200 MB/s/TiB
- **Use case**: Long-term storage, production workloads

### PERSISTENT_2 (Recommended)
- **Durability**: Replicated within AZ
- **Throughput**: 125, 250, 500, 1000 MB/s/TiB
- **Use case**: Highest performance production workloads

## Windows Deployment Types

### SINGLE_AZ_1
- **Availability**: Single AZ
- **Throughput**: 8-2048 MB/s
- **Storage**: HDD or SSD
- **Use case**: Dev/test, cost-sensitive workloads

### SINGLE_AZ_2 (Recommended)
- **Availability**: Single AZ
- **Throughput**: 8-2048 MB/s
- **Storage**: SSD only, latest features
- **Use case**: Production workloads in single AZ

### MULTI_AZ_1 (High Availability)
- **Availability**: Multi-AZ with automatic failover
- **Throughput**: 32-2048 MB/s
- **Storage**: SSD only
- **Use case**: Mission-critical workloads

## Performance Guidelines

### Lustre
- **Throughput**: 200-1000 MB/s/TiB depending on deployment
- **IOPS**: Millions (parallel workloads)
- **Latency**: Sub-millisecond
- **Best for**: HPC, machine learning, genomics, financial modeling

### Windows
- **Throughput**: Up to 2 GB/s
- **IOPS**: Up to 100,000
- **Latency**: Sub-millisecond
- **Best for**: Windows applications, file shares, SQL Server, home directories

### ONTAP
- **Throughput**: Up to 2 GB/s per file system
- **IOPS**: Up to 160,000
- **Features**: Snapshots, clones, replication
- **Best for**: Multi-protocol access, database workloads, backup/DR

### OpenZFS
- **Throughput**: Up to 4 GB/s
- **IOPS**: Up to 160,000
- **Features**: Compression, snapshots, point-in-time clones
- **Best for**: Linux workloads, Docker volumes, databases

## Cost Optimization

### Lustre
1. Use SCRATCH for temporary workloads (50% cheaper)
2. Link to S3 for long-term storage
3. Enable LZ4 compression (2-3x savings)
4. Right-size throughput tier

### Windows
1. Use HDD for infrequently accessed data (60% cheaper)
2. Start with SINGLE_AZ for non-critical workloads
3. Enable deduplication for redundant data
4. Use data tiering to move cold data to lower tiers

### ONTAP
1. Enable storage efficiency (compression, deduplication)
2. Use tiering to S3 for cold data
3. Snapshot efficiency (incremental)
4. Right-size volumes

### OpenZFS
1. Enable ZSTD compression (better than LZ4)
2. Use thin provisioning
3. Snapshot management (auto-delete old snapshots)
4. Right-size throughput capacity

## Security Best Practices

1. **VPC Isolation**: Deploy in private subnets
2. **Security Groups**: Restrict access to specific ports
   - Lustre: 988, 1021-1023
   - Windows: 445 (SMB), 5985 (WinRM)
   - ONTAP: 111, 635, 2049 (NFS), 445 (SMB)
   - OpenZFS: 111, 2049 (NFS)
3. **Encryption**: Always encrypt at rest with KMS
4. **Transit Encryption**: Use SMB 3.0+ for Windows
5. **IAM**: Use least privilege access
6. **Backups**: Enable automatic backups (7+ days)
7. **Audit Logs**: Enable for Windows and ONTAP
8. **AD Integration**: Use for Windows and ONTAP

## Monitoring

Key CloudWatch metrics:
- **StorageCapacity**: Total storage
- **StorageUsed**: Used storage
- **DataReadBytes/DataWriteBytes**: Throughput
- **DataReadOperations/DataWriteOperations**: IOPS
- **FreeStorageCapacity**: Available space

Set alarms for:
- Storage capacity > 80%
- Throughput approaching limits
- Failed backups

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |
