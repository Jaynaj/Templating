# FSx for Lustre
resource "aws_fsx_lustre_file_system" "this" {
  count = var.file_system_type == "LUSTRE" ? 1 : 0

  storage_capacity            = var.storage_capacity
  subnet_ids                  = var.subnet_ids
  deployment_type             = var.lustre_deployment_type
  storage_type                = var.storage_type
  per_unit_storage_throughput = var.per_unit_storage_throughput
  automatic_backup_retention_days = var.automatic_backup_retention_days
  copy_tags_to_backups        = var.copy_tags_to_backups
  daily_automatic_backup_start_time = var.daily_automatic_backup_start_time
  data_compression_type       = var.data_compression_type
  weekly_maintenance_start_time = var.weekly_maintenance_start_time
  security_group_ids          = var.security_group_ids
  kms_key_id                  = var.kms_key_id

  # S3 integration for Lustre
  import_path              = var.import_path
  export_path              = var.export_path
  imported_file_chunk_size = var.imported_file_chunk_size
  auto_import_policy       = var.auto_import_policy

  dynamic "log_configuration" {
    for_each = var.log_configuration != null ? [var.log_configuration] : []
    content {
      destination = lookup(log_configuration.value, "destination", null)
      level       = lookup(log_configuration.value, "level", "WARN_ERROR")
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
      Type = "Lustre"
    }
  )
}

# FSx for Windows File Server
resource "aws_fsx_windows_file_system" "this" {
  count = var.file_system_type == "WINDOWS" ? 1 : 0

  storage_capacity    = var.storage_capacity
  subnet_ids          = var.subnet_ids
  throughput_capacity = var.throughput_capacity
  deployment_type     = var.windows_deployment_type
  preferred_subnet_id = var.preferred_subnet_id
  storage_type        = var.storage_type

  # Active Directory integration
  active_directory_id = var.active_directory_id

  dynamic "self_managed_active_directory" {
    for_each = var.self_managed_active_directory != null ? [var.self_managed_active_directory] : []
    content {
      dns_ips                                = self_managed_active_directory.value.dns_ips
      domain_name                            = self_managed_active_directory.value.domain_name
      password                               = self_managed_active_directory.value.password
      username                               = self_managed_active_directory.value.username
      file_system_administrators_group       = lookup(self_managed_active_directory.value, "file_system_administrators_group", null)
      organizational_unit_distinguished_name = lookup(self_managed_active_directory.value, "organizational_unit_distinguished_name", null)
    }
  }

  # Backup and maintenance
  automatic_backup_retention_days   = var.automatic_backup_retention_days
  daily_automatic_backup_start_time = var.daily_automatic_backup_start_time
  weekly_maintenance_start_time     = var.weekly_maintenance_start_time
  copy_tags_to_backups              = var.copy_tags_to_backups
  skip_final_backup                 = var.skip_final_backup

  # Security
  security_group_ids = var.security_group_ids
  kms_key_id         = var.kms_key_id

  # Performance
  aliases = var.aliases

  dynamic "audit_log_configuration" {
    for_each = var.audit_log_configuration != null ? [var.audit_log_configuration] : []
    content {
      file_access_audit_log_level       = lookup(audit_log_configuration.value, "file_access_audit_log_level", "DISABLED")
      file_share_access_audit_log_level = lookup(audit_log_configuration.value, "file_share_access_audit_log_level", "DISABLED")
      audit_log_destination             = lookup(audit_log_configuration.value, "audit_log_destination", null)
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
      Type = "Windows"
    }
  )
}

# FSx for NetApp ONTAP
resource "aws_fsx_ontap_file_system" "this" {
  count = var.file_system_type == "ONTAP" ? 1 : 0

  storage_capacity                = var.storage_capacity
  subnet_ids                      = var.subnet_ids
  deployment_type                 = var.ontap_deployment_type
  preferred_subnet_id             = var.preferred_subnet_id
  throughput_capacity             = var.throughput_capacity
  endpoint_ip_address_range       = var.endpoint_ip_address_range
  route_table_ids                 = var.route_table_ids
  automatic_backup_retention_days = var.automatic_backup_retention_days
  daily_automatic_backup_start_time = var.daily_automatic_backup_start_time
  weekly_maintenance_start_time   = var.weekly_maintenance_start_time
  security_group_ids              = var.security_group_ids
  kms_key_id                      = var.kms_key_id
  fsx_admin_password              = var.fsx_admin_password

  dynamic "disk_iops_configuration" {
    for_each = var.disk_iops_configuration != null ? [var.disk_iops_configuration] : []
    content {
      mode = lookup(disk_iops_configuration.value, "mode", "AUTOMATIC")
      iops = lookup(disk_iops_configuration.value, "iops", null)
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
      Type = "ONTAP"
    }
  )
}

# FSx for OpenZFS
resource "aws_fsx_openzfs_file_system" "this" {
  count = var.file_system_type == "OPENZFS" ? 1 : 0

  storage_capacity            = var.storage_capacity
  subnet_ids                  = var.subnet_ids
  deployment_type             = var.openzfs_deployment_type
  throughput_capacity         = var.throughput_capacity
  storage_type                = var.storage_type
  automatic_backup_retention_days = var.automatic_backup_retention_days
  copy_tags_to_backups        = var.copy_tags_to_backups
  daily_automatic_backup_start_time = var.daily_automatic_backup_start_time
  weekly_maintenance_start_time = var.weekly_maintenance_start_time
  security_group_ids          = var.security_group_ids
  kms_key_id                  = var.kms_key_id

  dynamic "disk_iops_configuration" {
    for_each = var.disk_iops_configuration != null ? [var.disk_iops_configuration] : []
    content {
      mode = lookup(disk_iops_configuration.value, "mode", "AUTOMATIC")
      iops = lookup(disk_iops_configuration.value, "iops", null)
    }
  }

  dynamic "root_volume_configuration" {
    for_each = var.root_volume_configuration != null ? [var.root_volume_configuration] : []
    content {
      data_compression_type           = lookup(root_volume_configuration.value, "data_compression_type", "NONE")
      copy_tags_to_snapshots         = lookup(root_volume_configuration.value, "copy_tags_to_snapshots", false)
      read_only                      = lookup(root_volume_configuration.value, "read_only", false)
      record_size_kib                = lookup(root_volume_configuration.value, "record_size_kib", null)

      dynamic "nfs_exports" {
        for_each = lookup(root_volume_configuration.value, "nfs_exports", null) != null ? [root_volume_configuration.value.nfs_exports] : []
        content {
          dynamic "client_configurations" {
            for_each = nfs_exports.value.client_configurations
            content {
              clients = client_configurations.value.clients
              options = client_configurations.value.options
            }
          }
        }
      }

      dynamic "user_and_group_quotas" {
        for_each = lookup(root_volume_configuration.value, "user_and_group_quotas", [])
        content {
          id                         = user_and_group_quotas.value.id
          storage_capacity_quota_gib = user_and_group_quotas.value.storage_capacity_quota_gib
          type                       = user_and_group_quotas.value.type
        }
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
      Type = "OpenZFS"
    }
  )
}

# Data source for FSx backup
data "aws_fsx_openzfs_snapshot" "this" {
  count = var.file_system_type == "OPENZFS" && var.snapshot_id != null ? 1 : 0

  snapshot_ids = [var.snapshot_id]
}
