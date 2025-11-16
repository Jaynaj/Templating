output "id" {
  description = "ID of the SQL Server"
  value       = azurerm_mssql_server.this.id
}

output "name" {
  description = "Name of the SQL Server"
  value       = azurerm_mssql_server.this.name
}

output "fqdn" {
  description = "FQDN of the SQL Server"
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}

output "database_ids" {
  description = "IDs of the databases"
  value       = { for k, v in azurerm_mssql_database.this : k => v.id }
}
