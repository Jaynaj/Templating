output "id" {
  description = "ID of the Container Registry"
  value       = azurerm_container_registry.this.id
}

output "name" {
  description = "Name of the Container Registry"
  value       = azurerm_container_registry.this.name
}

output "login_server" {
  description = "Login server"
  value       = azurerm_container_registry.this.login_server
}

output "admin_username" {
  description = "Admin username"
  value       = azurerm_container_registry.this.admin_username
}

output "admin_password" {
  description = "Admin password"
  value       = azurerm_container_registry.this.admin_password
  sensitive   = true
}

output "identity" {
  description = "Managed identity"
  value       = azurerm_container_registry.this.identity
}
