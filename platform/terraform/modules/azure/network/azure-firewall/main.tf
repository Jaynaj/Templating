resource "azurerm_firewall" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  firewall_policy_id  = var.firewall_policy_id
  dns_servers         = length(var.dns_servers) > 0 ? var.dns_servers : null
  threat_intel_mode   = var.threat_intel_mode
  zones               = length(var.zones) > 0 ? var.zones : null

  ip_configuration {
    name                 = var.ip_configuration.name
    subnet_id            = var.ip_configuration.subnet_id
    public_ip_address_id = var.ip_configuration.public_ip_address_id
  }

  tags = var.tags
}
