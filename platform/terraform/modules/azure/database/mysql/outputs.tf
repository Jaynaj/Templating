output "id" {
  description = "ID of the MySQL Server"
  value       = azurerm_mysql_flexible_server.this.id
}

output "name" {
  description = "Name of the MySQL Server"
  value       = azurerm_mysql_flexible_server.this.name
}

output "fqdn" {
  description = "FQDN of the MySQL Server"
  value       = azurerm_mysql_flexible_server.this.fqdn
}

output "database_ids" {
  description = "IDs of the databases"
  value       = { for k, v in azurerm_mysql_flexible_database.this : k => v.id }
}
