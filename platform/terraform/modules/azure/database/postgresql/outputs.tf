output "id" {
  description = "ID of the PostgreSQL Server"
  value       = azurerm_postgresql_flexible_server.this.id
}

output "name" {
  description = "Name of the PostgreSQL Server"
  value       = azurerm_postgresql_flexible_server.this.name
}

output "fqdn" {
  description = "FQDN of the PostgreSQL Server"
  value       = azurerm_postgresql_flexible_server.this.fqdn
}

output "database_ids" {
  description = "IDs of the databases"
  value       = { for k, v in azurerm_postgresql_flexible_server_database.this : k => v.id }
}
