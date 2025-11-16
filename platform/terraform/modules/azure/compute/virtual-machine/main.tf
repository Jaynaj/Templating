resource "azurerm_linux_virtual_machine" "this" {
  count = var.os_type == "Linux" ? 1 : 0

  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  network_interface_ids           = var.network_interface_ids
  computer_name                   = var.computer_name != null ? var.computer_name : var.name
  zone                            = var.zone

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb         = lookup(var.os_disk, "disk_size_gb", null)
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_reference != null ? [var.source_image_reference] : []
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  source_image_id = var.source_image_id

  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_keys
    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_storage_account_uri != null ? [1] : []
    content {
      storage_account_uri = var.boot_diagnostics_storage_account_uri
    }
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine" "this" {
  count = var.os_type == "Windows" ? 1 : 0

  name                  = var.name
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = var.network_interface_ids
  computer_name         = var.computer_name != null ? var.computer_name : var.name
  zone                  = var.zone

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb         = lookup(var.os_disk, "disk_size_gb", null)
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_reference != null ? [var.source_image_reference] : []
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  source_image_id = var.source_image_id

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.boot_diagnostics_storage_account_uri != null ? [1] : []
    content {
      storage_account_uri = var.boot_diagnostics_storage_account_uri
    }
  }

  tags = var.tags
}
