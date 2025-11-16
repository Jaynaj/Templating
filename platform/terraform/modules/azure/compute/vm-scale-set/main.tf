resource "azurerm_linux_virtual_machine_scale_set" "this" {
  count = var.os_type == "Linux" ? 1 : 0

  name                            = var.name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  sku                             = var.sku
  instances                       = var.instances
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication
  upgrade_mode                    = var.upgrade_mode
  zones                           = length(var.zones) > 0 ? var.zones : null
  health_probe_id                 = var.health_probe_id

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  network_interface {
    name    = var.network_interface.name
    primary = var.network_interface.primary

    ip_configuration {
      name      = var.network_interface.ip_configuration.name
      primary   = var.network_interface.ip_configuration.primary
      subnet_id = var.network_interface.ip_configuration.subnet_id
      load_balancer_backend_address_pool_ids = lookup(var.network_interface.ip_configuration, "load_balancer_backend_address_pool_ids", null)
      application_gateway_backend_address_pool_ids = lookup(var.network_interface.ip_configuration, "application_gateway_backend_address_pool_ids", null)
    }
  }

  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_keys
    content {
      username   = var.admin_username
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

  dynamic "automatic_instance_repair" {
    for_each = var.automatic_instance_repair != null ? [var.automatic_instance_repair] : []
    content {
      enabled      = automatic_instance_repair.value.enabled
      grace_period = lookup(automatic_instance_repair.value, "grace_period", "PT30M")
    }
  }

  tags = var.tags
}

resource "azurerm_windows_virtual_machine_scale_set" "this" {
  count = var.os_type == "Windows" ? 1 : 0

  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  instances           = var.instances
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  upgrade_mode        = var.upgrade_mode
  zones               = length(var.zones) > 0 ? var.zones : null
  health_probe_id     = var.health_probe_id

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  network_interface {
    name    = var.network_interface.name
    primary = var.network_interface.primary

    ip_configuration {
      name      = var.network_interface.ip_configuration.name
      primary   = var.network_interface.ip_configuration.primary
      subnet_id = var.network_interface.ip_configuration.subnet_id
      load_balancer_backend_address_pool_ids = lookup(var.network_interface.ip_configuration, "load_balancer_backend_address_pool_ids", null)
      application_gateway_backend_address_pool_ids = lookup(var.network_interface.ip_configuration, "application_gateway_backend_address_pool_ids", null)
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  dynamic "automatic_instance_repair" {
    for_each = var.automatic_instance_repair != null ? [var.automatic_instance_repair] : []
    content {
      enabled      = automatic_instance_repair.value.enabled
      grace_period = lookup(automatic_instance_repair.value, "grace_period", "PT30M")
    }
  }

  tags = var.tags
}
