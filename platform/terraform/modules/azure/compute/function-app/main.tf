resource "azurerm_linux_function_app" "this" {
  name                       = var.name
  resource_group_name        = var.resource_group_name
  location                   = var.location
  service_plan_id            = var.service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  https_only                 = var.https_only
  client_certificate_enabled = var.client_certificate_enabled
  builtin_logging_enabled    = var.builtin_logging_enabled
  virtual_network_subnet_id  = var.virtual_network_subnet_id
  functions_extension_version = var.functions_extension_version

  app_settings = var.app_settings

  site_config {
    always_on                              = var.site_config != null ? lookup(var.site_config, "always_on", false) : false
    app_command_line                       = var.site_config != null ? lookup(var.site_config, "app_command_line", null) : null
    ftps_state                             = var.site_config != null ? lookup(var.site_config, "ftps_state", "FtpsOnly") : "FtpsOnly"
    health_check_path                      = var.site_config != null ? lookup(var.site_config, "health_check_path", null) : null
    http2_enabled                          = var.site_config != null ? lookup(var.site_config, "http2_enabled", false) : false
    minimum_tls_version                    = var.site_config != null ? lookup(var.site_config, "minimum_tls_version", "1.2") : "1.2"
    application_insights_key               = var.site_config != null ? lookup(var.site_config, "application_insights_key", null) : null
    application_insights_connection_string = var.site_config != null ? lookup(var.site_config, "application_insights_connection_string", null) : null
    runtime_scale_monitoring_enabled       = var.site_config != null ? lookup(var.site_config, "runtime_scale_monitoring_enabled", false) : false
    use_32_bit_worker                      = var.site_config != null ? lookup(var.site_config, "use_32_bit_worker", false) : false
    websockets_enabled                     = var.site_config != null ? lookup(var.site_config, "websockets_enabled", false) : false

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
