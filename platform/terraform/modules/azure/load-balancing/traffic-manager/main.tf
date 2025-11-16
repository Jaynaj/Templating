resource "azurerm_traffic_manager_profile" "this" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  traffic_routing_method = var.traffic_routing_method
  traffic_view_enabled   = var.traffic_view_enabled
  max_return             = var.max_return

  dns_config {
    relative_name = var.dns_config.relative_name
    ttl           = var.dns_config.ttl
  }

  monitor_config {
    protocol                     = var.monitor_config.protocol
    port                         = var.monitor_config.port
    path                         = lookup(var.monitor_config, "path", null)
    interval_in_seconds          = lookup(var.monitor_config, "interval_in_seconds", 30)
    timeout_in_seconds           = lookup(var.monitor_config, "timeout_in_seconds", 10)
    tolerated_number_of_failures = lookup(var.monitor_config, "tolerated_number_of_failures", 3)
    expected_status_code_ranges  = lookup(var.monitor_config, "expected_status_code_ranges", null)

    dynamic "custom_header" {
      for_each = lookup(var.monitor_config, "custom_header", [])
      content {
        name  = custom_header.value.name
        value = custom_header.value.value
      }
    }
  }

  tags = var.tags
}

resource "azurerm_traffic_manager_azure_endpoint" "this" {
  for_each = { for endpoint in var.endpoints : endpoint.name => endpoint if endpoint.type == "azureEndpoints" }

  name               = each.value.name
  profile_id         = azurerm_traffic_manager_profile.this.id
  target_resource_id = each.value.target_resource_id
  weight             = lookup(each.value, "weight", null)
  priority           = lookup(each.value, "priority", null)
  endpoint_location  = lookup(each.value, "endpoint_location", null)
  geo_mappings       = lookup(each.value, "geo_mappings", null)

  dynamic "custom_header" {
    for_each = lookup(each.value, "custom_header", [])
    content {
      name  = custom_header.value.name
      value = custom_header.value.value
    }
  }

  dynamic "subnet" {
    for_each = lookup(each.value, "subnet", [])
    content {
      first = subnet.value.first
      last  = lookup(subnet.value, "last", null)
      scope = lookup(subnet.value, "scope", null)
    }
  }
}

resource "azurerm_traffic_manager_external_endpoint" "this" {
  for_each = { for endpoint in var.endpoints : endpoint.name => endpoint if endpoint.type == "externalEndpoints" }

  name              = each.value.name
  profile_id        = azurerm_traffic_manager_profile.this.id
  target            = each.value.target
  weight            = lookup(each.value, "weight", null)
  priority          = lookup(each.value, "priority", null)
  endpoint_location = lookup(each.value, "endpoint_location", null)
  geo_mappings      = lookup(each.value, "geo_mappings", null)

  dynamic "custom_header" {
    for_each = lookup(each.value, "custom_header", [])
    content {
      name  = custom_header.value.name
      value = custom_header.value.value
    }
  }

  dynamic "subnet" {
    for_each = lookup(each.value, "subnet", [])
    content {
      first = subnet.value.first
      last  = lookup(subnet.value, "last", null)
      scope = lookup(subnet.value, "scope", null)
    }
  }
}

resource "azurerm_traffic_manager_nested_endpoint" "this" {
  for_each = { for endpoint in var.endpoints : endpoint.name => endpoint if endpoint.type == "nestedEndpoints" }

  name                    = each.value.name
  profile_id              = azurerm_traffic_manager_profile.this.id
  target_resource_id      = each.value.target_resource_id
  weight                  = lookup(each.value, "weight", null)
  priority                = lookup(each.value, "priority", null)
  endpoint_location       = lookup(each.value, "endpoint_location", null)
  minimum_child_endpoints = lookup(each.value, "min_child_endpoints", 1)
  geo_mappings            = lookup(each.value, "geo_mappings", null)

  dynamic "custom_header" {
    for_each = lookup(each.value, "custom_header", [])
    content {
      name  = custom_header.value.name
      value = custom_header.value.value
    }
  }

  dynamic "subnet" {
    for_each = lookup(each.value, "subnet", [])
    content {
      first = subnet.value.first
      last  = lookup(subnet.value, "last", null)
      scope = lookup(subnet.value, "scope", null)
    }
  }
}
