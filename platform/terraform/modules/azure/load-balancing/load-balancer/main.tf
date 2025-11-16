resource "azurerm_lb" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  sku_tier            = var.sku_tier

  dynamic "frontend_ip_configuration" {
    for_each = var.frontend_ip_configurations
    content {
      name                          = frontend_ip_configuration.value.name
      zones                         = lookup(frontend_ip_configuration.value, "zones", null)
      subnet_id                     = lookup(frontend_ip_configuration.value, "subnet_id", null)
      private_ip_address            = lookup(frontend_ip_configuration.value, "private_ip_address", null)
      private_ip_address_allocation = lookup(frontend_ip_configuration.value, "private_ip_address_allocation", "Dynamic")
      private_ip_address_version    = lookup(frontend_ip_configuration.value, "private_ip_address_version", "IPv4")
      public_ip_address_id          = lookup(frontend_ip_configuration.value, "public_ip_address_id", null)
    }
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "this" {
  for_each = toset(var.backend_address_pools)

  name            = each.value
  loadbalancer_id = azurerm_lb.this.id
}

resource "azurerm_lb_probe" "this" {
  for_each = { for probe in var.probes : probe.name => probe }

  name                = each.value.name
  loadbalancer_id     = azurerm_lb.this.id
  protocol            = each.value.protocol
  port                = each.value.port
  request_path        = each.value.protocol == "Http" || each.value.protocol == "Https" ? lookup(each.value, "request_path", "/") : null
  interval_in_seconds = lookup(each.value, "interval_in_seconds", 15)
  number_of_probes    = lookup(each.value, "number_of_probes", 2)
}

resource "azurerm_lb_rule" "this" {
  for_each = { for rule in var.load_balancing_rules : rule.name => rule }

  name                           = each.value.name
  loadbalancer_id                = azurerm_lb.this.id
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this[each.value.backend_address_pool_name].id]
  probe_id                       = azurerm_lb_probe.this[each.value.probe_name].id
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  enable_floating_ip             = lookup(each.value, "enable_floating_ip", false)
  idle_timeout_in_minutes        = lookup(each.value, "idle_timeout_in_minutes", 4)
  load_distribution              = lookup(each.value, "load_distribution", "Default")
  disable_outbound_snat          = lookup(each.value, "disable_outbound_snat", false)
  enable_tcp_reset               = lookup(each.value, "enable_tcp_reset", false)
}

resource "azurerm_lb_nat_rule" "this" {
  for_each = { for rule in var.inbound_nat_rules : rule.name => rule }

  name                           = each.value.name
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.this.id
  frontend_ip_configuration_name = each.value.frontend_ip_configuration_name
  protocol                       = each.value.protocol
  frontend_port                  = each.value.frontend_port
  backend_port                   = each.value.backend_port
  enable_floating_ip             = lookup(each.value, "enable_floating_ip", false)
  idle_timeout_in_minutes        = lookup(each.value, "idle_timeout_in_minutes", 4)
  enable_tcp_reset               = lookup(each.value, "enable_tcp_reset", false)
}

resource "azurerm_lb_outbound_rule" "this" {
  for_each = var.sku == "Standard" ? { for rule in var.outbound_rules : rule.name => rule } : {}

  name                     = each.value.name
  loadbalancer_id          = azurerm_lb.this.id
  backend_address_pool_id  = azurerm_lb_backend_address_pool.this[each.value.backend_address_pool_name].id
  protocol                 = each.value.protocol
  allocated_outbound_ports = lookup(each.value, "allocated_outbound_ports", null)
  idle_timeout_in_minutes  = lookup(each.value, "idle_timeout_in_minutes", 4)
  enable_tcp_reset         = lookup(each.value, "enable_tcp_reset", false)

  dynamic "frontend_ip_configuration" {
    for_each = each.value.frontend_ip_configuration_names
    content {
      name = frontend_ip_configuration.value
    }
  }
}
