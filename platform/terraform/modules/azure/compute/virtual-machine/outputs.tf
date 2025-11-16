output "id" {
  description = "ID of the Virtual Machine"
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine.this[0].id : azurerm_windows_virtual_machine.this[0].id
}

output "name" {
  description = "Name of the Virtual Machine"
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine.this[0].name : azurerm_windows_virtual_machine.this[0].name
}

output "private_ip_address" {
  description = "Private IP address of the VM"
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine.this[0].private_ip_address : azurerm_windows_virtual_machine.this[0].private_ip_address
}

output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine.this[0].public_ip_address : azurerm_windows_virtual_machine.this[0].public_ip_address
}

output "identity" {
  description = "Managed identity of the VM"
  value       = var.os_type == "Linux" ? azurerm_linux_virtual_machine.this[0].identity : azurerm_windows_virtual_machine.this[0].identity
}
