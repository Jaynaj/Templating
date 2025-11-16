resource "azurerm_postgresql_flexible_server" "this" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  sku_name               = var.sku_name
  storage_mb             = var.storage_mb
  version                = var.version
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  backup_retention_days  = var.backup_retention_days
  geo_redundant_backup_enabled = var.geo_redundant_backup_enabled
  zone                   = var.zone

  dynamic "high_availability" {
    for_each = var.high_availability != null ? [var.high_availability] : []
    content {
      mode                      = high_availability.value.mode
      standby_availability_zone = lookup(high_availability.value, "standby_availability_zone", null)
    }
  }

  tags = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "this" {
  for_each = var.databases

  name      = each.key
  server_id = azurerm_postgresql_flexible_server.this.id
  charset   = lookup(each.value, "charset", "UTF8")
  collation = lookup(each.value, "collation", "en_US.utf8")
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "this" {
  for_each = var.firewall_rules

  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.this.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}
