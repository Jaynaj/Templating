output "id" {
  description = "ID of the Traffic Manager Profile"
  value       = azurerm_traffic_manager_profile.this.id
}

output "name" {
  description = "Name of the Traffic Manager Profile"
  value       = azurerm_traffic_manager_profile.this.name
}

output "fqdn" {
  description = "FQDN of the Traffic Manager Profile"
  value       = azurerm_traffic_manager_profile.this.fqdn
}
