output "id" {
  description = "ID of the Front Door Profile"
  value       = azurerm_cdn_frontdoor_profile.this.id
}

output "name" {
  description = "Name of the Front Door Profile"
  value       = azurerm_cdn_frontdoor_profile.this.name
}

output "endpoint_ids" {
  description = "IDs of the endpoints"
  value       = { for k, v in azurerm_cdn_frontdoor_endpoint.this : k => v.id }
}

output "endpoint_host_names" {
  description = "Host names of the endpoints"
  value       = { for k, v in azurerm_cdn_frontdoor_endpoint.this : k => v.host_name }
}

output "origin_group_ids" {
  description = "IDs of the origin groups"
  value       = { for k, v in azurerm_cdn_frontdoor_origin_group.this : k => v.id }
}
