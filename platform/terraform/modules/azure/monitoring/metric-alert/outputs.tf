output "id" {
  description = "ID of the Metric Alert"
  value       = azurerm_monitor_metric_alert.this.id
}

output "name" {
  description = "Name of the Metric Alert"
  value       = azurerm_monitor_metric_alert.this.name
}
