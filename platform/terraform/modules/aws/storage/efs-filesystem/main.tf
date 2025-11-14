resource "aws_efs_file_system" "this" {
  creation_token   = var.creation_token
  encrypted        = var.encrypted
  kms_key_id       = var.kms_key_id
  performance_mode = var.performance_mode
  throughput_mode  = var.throughput_mode

  # Provisioned throughput (only when throughput_mode is "provisioned")
  provisioned_throughput_in_mibps = var.throughput_mode == "provisioned" ? var.provisioned_throughput_in_mibps : null

  # Lifecycle policy
  dynamic "lifecycle_policy" {
    for_each = var.transition_to_ia != null ? [var.transition_to_ia] : []
    content {
      transition_to_ia = lifecycle_policy.value
    }
  }

  dynamic "lifecycle_policy" {
    for_each = var.transition_to_primary_storage_class != null ? [var.transition_to_primary_storage_class] : []
    content {
      transition_to_primary_storage_class = lifecycle_policy.value
    }
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

# Mount targets (one per subnet)
resource "aws_efs_mount_target" "this" {
  count = length(var.subnet_ids)

  file_system_id  = aws_efs_file_system.this.id
  subnet_id       = var.subnet_ids[count.index]
  security_groups = var.security_group_ids

  # Optionally specify IP address
  ip_address = length(var.mount_target_ip_addresses) > count.index ? var.mount_target_ip_addresses[count.index] : null
}

# Access points for application-specific access
resource "aws_efs_access_point" "this" {
  for_each = var.access_points

  file_system_id = aws_efs_file_system.this.id

  posix_user {
    gid            = each.value.posix_user.gid
    uid            = each.value.posix_user.uid
    secondary_gids = lookup(each.value.posix_user, "secondary_gids", null)
  }

  root_directory {
    path = each.value.root_directory.path

    dynamic "creation_info" {
      for_each = lookup(each.value.root_directory, "creation_info", null) != null ? [each.value.root_directory.creation_info] : []
      content {
        owner_gid   = creation_info.value.owner_gid
        owner_uid   = creation_info.value.owner_uid
        permissions = creation_info.value.permissions
      }
    }
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${each.key}"
    }
  )
}

# File system policy
resource "aws_efs_file_system_policy" "this" {
  count = var.file_system_policy != null ? 1 : 0

  file_system_id = aws_efs_file_system.this.id
  policy         = var.file_system_policy
}

# Backup policy
resource "aws_efs_backup_policy" "this" {
  count = var.enable_backup_policy ? 1 : 0

  file_system_id = aws_efs_file_system.this.id

  backup_policy {
    status = "ENABLED"
  }
}

# Replication configuration
resource "aws_efs_replication_configuration" "this" {
  count = var.replication_configuration != null ? 1 : 0

  source_file_system_id = aws_efs_file_system.this.id

  destination {
    region                 = var.replication_configuration.region
    availability_zone_name = lookup(var.replication_configuration, "availability_zone_name", null)
    kms_key_id             = lookup(var.replication_configuration, "kms_key_id", null)
  }
}
