output "id" {
  description = "ID of the User Assigned Identity"
  value       = azurerm_user_assigned_identity.this.id
}

output "name" {
  description = "Name of the User Assigned Identity"
  value       = azurerm_user_assigned_identity.this.name
}

output "principal_id" {
  description = "Principal ID"
  value       = azurerm_user_assigned_identity.this.principal_id
}

output "client_id" {
  description = "Client ID"
  value       = azurerm_user_assigned_identity.this.client_id
}

output "tenant_id" {
  description = "Tenant ID"
  value       = azurerm_user_assigned_identity.this.tenant_id
}
