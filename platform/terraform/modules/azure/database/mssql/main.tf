resource "azurerm_mssql_server" "this" {
  name                         = var.name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  minimum_tls_version          = var.minimum_tls_version
  public_network_access_enabled = var.public_network_access_enabled

  dynamic "azuread_administrator" {
    for_each = var.azuread_administrator != null ? [var.azuread_administrator] : []
    content {
      login_username = azuread_administrator.value.login_username
      object_id      = azuread_administrator.value.object_id
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

resource "azurerm_mssql_database" "this" {
  for_each = var.databases

  name                        = each.key
  server_id                   = azurerm_mssql_server.this.id
  collation                   = lookup(each.value, "collation", "SQL_Latin1_General_CP1_CI_AS")
  sku_name                    = lookup(each.value, "sku_name", "S0")
  max_size_gb                 = lookup(each.value, "max_size_gb", null)
  zone_redundant              = lookup(each.value, "zone_redundant", false)
  read_scale                  = lookup(each.value, "read_scale", false)
  auto_pause_delay_in_minutes = lookup(each.value, "auto_pause_delay_in_minutes", null)
  min_capacity                = lookup(each.value, "min_capacity", null)

  tags = var.tags
}

resource "azurerm_mssql_firewall_rule" "this" {
  for_each = var.firewall_rules

  name             = each.key
  server_id        = azurerm_mssql_server.this.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}
