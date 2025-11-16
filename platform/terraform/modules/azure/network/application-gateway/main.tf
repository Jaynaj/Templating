resource "azurerm_application_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  enable_http2        = var.enable_http2

  sku {
    name     = var.sku.name
    tier     = var.sku.tier
    capacity = lookup(var.sku, "capacity", 2)
  }

  gateway_ip_configuration {
    name      = var.gateway_ip_configuration.name
    subnet_id = var.gateway_ip_configuration.subnet_id
  }

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    content {
      name                          = frontend_ip_configuration.value.name
      subnet_id                     = lookup(frontend_ip_configuration.value, "subnet_id", null)
      private_ip_address            = lookup(frontend_ip_configuration.value, "private_ip_address", null)
      private_ip_address_allocation = lookup(frontend_ip_configuration.value, "private_ip_address_allocation", null)
      public_ip_address_id          = lookup(frontend_ip_configuration.value, "public_ip_address_id", null)
    }
  }

  dynamic "frontend_port" {
    for_each = var.frontend_ports
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "backend_address_pool" {
    for_each = var.backend_address_pools
    content {
      name         = backend_address_pool.value.name
      fqdns        = lookup(backend_address_pool.value, "fqdns", null)
      ip_addresses = lookup(backend_address_pool.value, "ip_addresses", null)
    }
  }

  dynamic "backend_http_settings" {
    for_each = var.backend_http_settings
    content {
      name                                = backend_http_settings.value.name
      cookie_based_affinity               = backend_http_settings.value.cookie_based_affinity
      port                                = backend_http_settings.value.port
      protocol                            = backend_http_settings.value.protocol
      request_timeout                     = lookup(backend_http_settings.value, "request_timeout", 30)
      probe_name                          = lookup(backend_http_settings.value, "probe_name", null)
      pick_host_name_from_backend_address = lookup(backend_http_settings.value, "pick_host_name_from_backend_address", false)
    }
  }

  dynamic "http_listener" {
    for_each = var.http_listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.frontend_ip_configuration_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
      ssl_certificate_name           = lookup(http_listener.value, "ssl_certificate_name", null)
      host_name                      = lookup(http_listener.value, "host_name", null)
    }
  }

  dynamic "request_routing_rule" {
    for_each = var.request_routing_rules
    content {
      name                       = request_routing_rule.value.name
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = lookup(request_routing_rule.value, "backend_address_pool_name", null)
      backend_http_settings_name = lookup(request_routing_rule.value, "backend_http_settings_name", null)
      priority                   = request_routing_rule.value.priority
    }
  }

  dynamic "ssl_certificate" {
    for_each = var.ssl_certificates
    content {
      name     = ssl_certificate.value.name
      data     = lookup(ssl_certificate.value, "data", null)
      password = lookup(ssl_certificate.value, "password", null)
    }
  }

  dynamic "probe" {
    for_each = var.probes
    content {
      name                                      = probe.value.name
      protocol                                  = probe.value.protocol
      path                                      = probe.value.path
      interval                                  = probe.value.interval
      timeout                                   = probe.value.timeout
      unhealthy_threshold                       = probe.value.unhealthy_threshold
      pick_host_name_from_backend_http_settings = lookup(probe.value, "pick_host_name_from_backend_http_settings", false)
      host                                      = lookup(probe.value, "host", null)
    }
  }

  dynamic "waf_configuration" {
    for_each = var.waf_configuration != null ? [var.waf_configuration] : []
    content {
      enabled          = waf_configuration.value.enabled
      firewall_mode    = waf_configuration.value.firewall_mode
      rule_set_type    = waf_configuration.value.rule_set_type
      rule_set_version = waf_configuration.value.rule_set_version
    }
  }

  tags = var.tags
}
