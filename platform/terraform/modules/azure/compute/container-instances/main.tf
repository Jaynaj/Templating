resource "azurerm_container_group" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = var.os_type
  restart_policy      = var.restart_policy
  ip_address_type     = var.ip_address_type
  dns_name_label      = var.dns_name_label
  subnet_ids          = length(var.subnet_ids) > 0 ? var.subnet_ids : null

  dynamic "container" {
    for_each = var.containers
    content {
      name   = container.value.name
      image  = container.value.image
      cpu    = container.value.cpu
      memory = container.value.memory

      dynamic "ports" {
        for_each = lookup(container.value, "ports", [])
        content {
          port     = ports.value.port
          protocol = ports.value.protocol
        }
      }

      environment_variables        = lookup(container.value, "environment_variables", null)
      secure_environment_variables = lookup(container.value, "secure_environment_variables", null)
      commands                     = lookup(container.value, "commands", null)

      dynamic "volume" {
        for_each = lookup(container.value, "volume", [])
        content {
          name       = volume.value.name
          mount_path = volume.value.mount_path
          read_only  = lookup(volume.value, "read_only", false)
          share_name = lookup(volume.value, "share_name", null)
          storage_account_name = lookup(volume.value, "storage_account_name", null)
          storage_account_key  = lookup(volume.value, "storage_account_key", null)
        }
      }
    }
  }

  dynamic "image_registry_credential" {
    for_each = var.image_registry_credential != null ? [var.image_registry_credential] : []
    content {
      server   = image_registry_credential.value.server
      username = image_registry_credential.value.username
      password = image_registry_credential.value.password
    }
  }

  dynamic "identity" {
    for_each = var.identity != null ? [var.identity] : []
    content {
      type         = identity.value.type
      identity_ids = lookup(identity.value, "identity_ids", null)
    }
  }

  tags = var.tags
}
