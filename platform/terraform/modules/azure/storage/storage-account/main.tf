resource "azurerm_storage_account" "this" {
  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  account_kind                    = var.account_kind
  access_tier                     = var.access_tier
  enable_https_traffic_only       = var.enable_https_traffic_only
  min_tls_version                 = var.min_tls_version
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public
  shared_access_key_enabled       = var.shared_access_key_enabled

  dynamic "network_rules" {
    for_each = var.network_rules != null ? [var.network_rules] : []
    content {
      default_action             = network_rules.value.default_action
      bypass                     = lookup(network_rules.value, "bypass", ["AzureServices"])
      ip_rules                   = lookup(network_rules.value, "ip_rules", [])
      virtual_network_subnet_ids = lookup(network_rules.value, "virtual_network_subnet_ids", [])
    }
  }

  dynamic "blob_properties" {
    for_each = var.blob_properties != null ? [var.blob_properties] : []
    content {
      versioning_enabled       = lookup(blob_properties.value, "versioning_enabled", false)
      change_feed_enabled      = lookup(blob_properties.value, "change_feed_enabled", false)
      last_access_time_enabled = lookup(blob_properties.value, "last_access_time_enabled", false)

      dynamic "delete_retention_policy" {
        for_each = lookup(blob_properties.value, "delete_retention_policy", null) != null ? [blob_properties.value.delete_retention_policy] : []
        content {
          days = delete_retention_policy.value.days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = lookup(blob_properties.value, "container_delete_retention_policy", null) != null ? [blob_properties.value.container_delete_retention_policy] : []
        content {
          days = container_delete_retention_policy.value.days
        }
      }
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
