output "id" {
  description = "ID of the role assignment"
  value       = azurerm_role_assignment.this.id
}

output "principal_type" {
  description = "Principal type"
  value       = azurerm_role_assignment.this.principal_type
}
