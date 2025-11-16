output "id" {
  description = "ID of the VPN Gateway"
  value       = azurerm_virtual_network_gateway.this.id
}

output "name" {
  description = "Name of the VPN Gateway"
  value       = azurerm_virtual_network_gateway.this.name
}
