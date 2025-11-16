output "id" {
  description = "ID of the Virtual Network"
  value       = azurerm_virtual_network.this.id
}

output "name" {
  description = "Name of the Virtual Network"
  value       = azurerm_virtual_network.this.name
}

output "address_space" {
  description = "Address space of the Virtual Network"
  value       = azurerm_virtual_network.this.address_space
}

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_virtual_network.this.resource_group_name
}
