output "id" {
  description = "ID of the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.this.id
}

output "name" {
  description = "Name of the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.this.name
}

output "endpoint" {
  description = "Endpoint of the Cosmos DB Account"
  value       = azurerm_cosmosdb_account.this.endpoint
}

output "primary_key" {
  description = "Primary key"
  value       = azurerm_cosmosdb_account.this.primary_key
  sensitive   = true
}

output "secondary_key" {
  description = "Secondary key"
  value       = azurerm_cosmosdb_account.this.secondary_key
  sensitive   = true
}

output "connection_strings" {
  description = "Connection strings"
  value       = azurerm_cosmosdb_account.this.connection_strings
  sensitive   = true
}
