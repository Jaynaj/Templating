output "id" {
  description = "ID of the Load Balancer"
  value       = azurerm_lb.this.id
}

output "name" {
  description = "Name of the Load Balancer"
  value       = azurerm_lb.this.name
}

output "frontend_ip_configurations" {
  description = "Frontend IP configurations"
  value       = azurerm_lb.this.frontend_ip_configuration
}

output "backend_address_pool_ids" {
  description = "Backend address pool IDs"
  value       = { for k, v in azurerm_lb_backend_address_pool.this : k => v.id }
}

output "probe_ids" {
  description = "Probe IDs"
  value       = { for k, v in azurerm_lb_probe.this : k => v.id }
}
