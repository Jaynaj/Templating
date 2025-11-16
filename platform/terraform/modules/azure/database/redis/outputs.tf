output "id" {
  description = "ID of the Redis Cache"
  value       = azurerm_redis_cache.this.id
}

output "name" {
  description = "Name of the Redis Cache"
  value       = azurerm_redis_cache.this.name
}

output "hostname" {
  description = "Hostname of the Redis Cache"
  value       = azurerm_redis_cache.this.hostname
}

output "ssl_port" {
  description = "SSL port"
  value       = azurerm_redis_cache.this.ssl_port
}

output "port" {
  description = "Non-SSL port"
  value       = azurerm_redis_cache.this.port
}

output "primary_access_key" {
  description = "Primary access key"
  value       = azurerm_redis_cache.this.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "Secondary access key"
  value       = azurerm_redis_cache.this.secondary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "Primary connection string"
  value       = azurerm_redis_cache.this.primary_connection_string
  sensitive   = true
}

output "secondary_connection_string" {
  description = "Secondary connection string"
  value       = azurerm_redis_cache.this.secondary_connection_string
  sensitive   = true
}
