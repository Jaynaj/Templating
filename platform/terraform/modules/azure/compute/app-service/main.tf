resource "azurerm_linux_web_app" "this" {
  name                      = var.name
  resource_group_name       = var.resource_group_name
  location                  = var.location
  service_plan_id           = var.service_plan_id
  https_only                = var.https_only
  client_affinity_enabled   = var.client_affinity_enabled
  virtual_network_subnet_id = var.virtual_network_subnet_id

  app_settings = var.app_settings

  dynamic "connection_string" {
    for_each = var.connection_string
    content {
      name  = connection_string.value.name
      type  = connection_string.value.type
      value = connection_string.value.value
    }
  }

  site_config {
    always_on             = var.site_config != null ? lookup(var.site_config, "always_on", true) : true
    app_command_line      = var.site_config != null ? lookup(var.site_config, "app_command_line", null) : null
    ftps_state            = var.site_config != null ? lookup(var.site_config, "ftps_state", "FtpsOnly") : "FtpsOnly"
    health_check_path     = var.site_config != null ? lookup(var.site_config, "health_check_path", null) : null
    http2_enabled         = var.site_config != null ? lookup(var.site_config, "http2_enabled", false) : false
    minimum_tls_version   = var.site_config != null ? lookup(var.site_config, "minimum_tls_version", "1.2") : "1.2"
    websockets_enabled    = var.site_config != null ? lookup(var.site_config, "websockets_enabled", false) : false

    dynamic "cors" {
      for_each = var.site_config != null && lookup(var.site_config, "cors", null) != null ? [var.site_config.cors] : []
      content {
        allowed_origins     = cors.value.allowed_origins
        support_credentials = lookup(cors.value, "support_credentials", false)
      }
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
