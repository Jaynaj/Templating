output "id" {
  description = "ID of the Azure Firewall"
  value       = azurerm_firewall.this.id
}

output "name" {
  description = "Name of the Azure Firewall"
  value       = azurerm_firewall.this.name
}

output "private_ip_address" {
  description = "Private IP address of the Firewall"
  value       = azurerm_firewall.this.ip_configuration[0].private_ip_address
}
