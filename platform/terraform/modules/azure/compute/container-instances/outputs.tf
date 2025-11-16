output "id" {
  description = "ID of the Container Group"
  value       = azurerm_container_group.this.id
}

output "name" {
  description = "Name of the Container Group"
  value       = azurerm_container_group.this.name
}

output "ip_address" {
  description = "IP address of the Container Group"
  value       = azurerm_container_group.this.ip_address
}

output "fqdn" {
  description = "FQDN of the Container Group"
  value       = azurerm_container_group.this.fqdn
}
