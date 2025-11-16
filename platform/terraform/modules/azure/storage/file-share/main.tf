resource "azurerm_storage_share" "this" {
  name                 = var.name
  storage_account_name = var.storage_account_name
  quota                = var.quota
  enabled_protocol     = var.enabled_protocol
  access_tier          = var.access_tier
  metadata             = var.metadata
}
