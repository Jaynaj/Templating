output "id" {
  description = "ID of the blob container"
  value       = azurerm_storage_container.this.id
}

output "name" {
  description = "Name of the blob container"
  value       = azurerm_storage_container.this.name
}

output "resource_manager_id" {
  description = "Resource Manager ID of the container"
  value       = azurerm_storage_container.this.resource_manager_id
}
