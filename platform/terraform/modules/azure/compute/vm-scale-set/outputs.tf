output "id" {
  description = "ID of the VM Scale Set"
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine_scale_set.this[0].id : azurerm_windows_virtual_machine_scale_set.this[0].id
}

output "name" {
  description = "Name of the VM Scale Set"
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine_scale_set.this[0].name : azurerm_windows_virtual_machine_scale_set.this[0].name
}

output "unique_id" {
  description = "Unique ID of the VM Scale Set"
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine_scale_set.this[0].unique_id : azurerm_windows_virtual_machine_scale_set.this[0].unique_id
}
