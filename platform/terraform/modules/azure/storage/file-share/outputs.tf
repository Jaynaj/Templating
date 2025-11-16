output "id" {
  description = "ID of the file share"
  value       = azurerm_storage_share.this.id
}

output "name" {
  description = "Name of the file share"
  value       = azurerm_storage_share.this.name
}

output "url" {
  description = "URL of the file share"
  value       = azurerm_storage_share.this.url
}

output "resource_manager_id" {
  description = "Resource Manager ID of the file share"
  value       = azurerm_storage_share.this.resource_manager_id
}
