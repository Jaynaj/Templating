resource "azurerm_redis_cache" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  capacity                      = var.capacity
  family                        = var.family
  sku_name                      = var.sku_name
  enable_non_ssl_port           = var.enable_non_ssl_port
  minimum_tls_version           = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled
  subnet_id                     = var.subnet_id
  private_static_ip_address     = var.private_static_ip_address
  zones                         = length(var.zones) > 0 ? var.zones : null
  replicas_per_master           = var.replicas_per_master
  replicas_per_primary          = var.replicas_per_primary
  shard_count                   = var.shard_count

  dynamic "redis_configuration" {
    for_each = var.redis_configuration != null ? [var.redis_configuration] : []
    content {
      maxmemory_policy                     = lookup(redis_configuration.value, "maxmemory_policy", null)
      maxmemory_reserved                   = lookup(redis_configuration.value, "maxmemory_reserved", null)
      maxfragmentationmemory_reserved      = lookup(redis_configuration.value, "maxfragmentationmemory_reserved", null)
      maxmemory_delta                      = lookup(redis_configuration.value, "maxmemory_delta", null)
      rdb_backup_enabled                   = lookup(redis_configuration.value, "rdb_backup_enabled", null)
      rdb_backup_frequency                 = lookup(redis_configuration.value, "rdb_backup_frequency", null)
      rdb_backup_max_snapshot_count        = lookup(redis_configuration.value, "rdb_backup_max_snapshot_count", null)
      rdb_storage_connection_string        = lookup(redis_configuration.value, "rdb_storage_connection_string", null)
      aof_backup_enabled                   = lookup(redis_configuration.value, "aof_backup_enabled", null)
      aof_storage_connection_string_0      = lookup(redis_configuration.value, "aof_storage_connection_string_0", null)
      aof_storage_connection_string_1      = lookup(redis_configuration.value, "aof_storage_connection_string_1", null)
      enable_authentication                = lookup(redis_configuration.value, "enable_authentication", true)
    }
  }

  dynamic "patch_schedule" {
    for_each = var.patch_schedule
    content {
      day_of_week        = patch_schedule.value.day_of_week
      start_hour_utc     = lookup(patch_schedule.value, "start_hour_utc", 0)
      maintenance_window = lookup(patch_schedule.value, "maintenance_window", null)
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  tags = var.tags
}
