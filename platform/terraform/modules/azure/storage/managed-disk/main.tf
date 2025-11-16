resource "azurerm_managed_disk" "this" {
  name                          = var.name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  storage_account_type          = var.storage_account_type
  create_option                 = var.create_option
  disk_size_gb                  = var.disk_size_gb
  source_resource_id            = var.source_resource_id
  source_uri                    = var.source_uri
  image_reference_id            = var.image_reference_id
  zone                          = var.zone
  disk_encryption_set_id        = var.disk_encryption_set_id
  network_access_policy         = var.network_access_policy
  public_network_access_enabled = var.public_network_access_enabled
  tier                          = var.tier
  max_shares                    = var.max_shares

  tags = var.tags
}
