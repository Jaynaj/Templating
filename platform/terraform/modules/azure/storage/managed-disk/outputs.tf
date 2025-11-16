output "id" {
  description = "ID of the managed disk"
  value       = azurerm_managed_disk.this.id
}

output "name" {
  description = "Name of the managed disk"
  value       = azurerm_managed_disk.this.name
}
