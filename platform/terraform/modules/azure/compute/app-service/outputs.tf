output "id" {
  description = "ID of the App Service"
  value       = azurerm_linux_web_app.this.id
}

output "name" {
  description = "Name of the App Service"
  value       = azurerm_linux_web_app.this.name
}

output "default_hostname" {
  description = "Default hostname of the App Service"
  value       = azurerm_linux_web_app.this.default_hostname
}

output "outbound_ip_addresses" {
  description = "Outbound IP addresses"
  value       = azurerm_linux_web_app.this.outbound_ip_addresses
}

output "possible_outbound_ip_addresses" {
  description = "Possible outbound IP addresses"
  value       = azurerm_linux_web_app.this.possible_outbound_ip_addresses
}

output "identity" {
  description = "Managed identity"
  value       = azurerm_linux_web_app.this.identity
}
