resource "azurerm_virtual_network_gateway" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  type                = var.type
  vpn_type            = var.type == "Vpn" ? var.vpn_type : null
  sku                 = var.sku
  generation          = var.generation
  enable_bgp          = var.enable_bgp
  active_active       = var.active_active

  ip_configuration {
    name                          = var.ip_configuration.name
    public_ip_address_id          = var.ip_configuration.public_ip_address_id
    private_ip_address_allocation = lookup(var.ip_configuration, "private_ip_address_allocation", "Dynamic")
    subnet_id                     = var.ip_configuration.subnet_id
  }

  dynamic "ip_configuration" {
    for_each = var.active_active && var.secondary_ip_configuration != null ? [var.secondary_ip_configuration] : []
    content {
      name                          = ip_configuration.value.name
      public_ip_address_id          = ip_configuration.value.public_ip_address_id
      private_ip_address_allocation = lookup(ip_configuration.value, "private_ip_address_allocation", "Dynamic")
      subnet_id                     = ip_configuration.value.subnet_id
    }
  }

  tags = var.tags
}
