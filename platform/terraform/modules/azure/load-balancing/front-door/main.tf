resource "azurerm_cdn_frontdoor_profile" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name

  tags = var.tags
}

resource "azurerm_cdn_frontdoor_endpoint" "this" {
  for_each = { for endpoint in var.endpoints : endpoint.name => endpoint }

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
  enabled                  = lookup(each.value, "enabled", true)

  tags = var.tags
}

resource "azurerm_cdn_frontdoor_origin_group" "this" {
  for_each = { for group in var.origin_groups : group.name => group }

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  health_probe {
    interval_in_seconds = each.value.health_probe.interval_in_seconds
    path                = each.value.health_probe.path
    protocol            = each.value.health_probe.protocol
    request_type        = each.value.health_probe.request_type
  }

  load_balancing {
    additional_latency_in_milliseconds = lookup(each.value.load_balancing, "additional_latency_in_milliseconds", 50)
    sample_size                        = lookup(each.value.load_balancing, "sample_size", 4)
    successful_samples_required        = lookup(each.value.load_balancing, "successful_samples_required", 3)
  }
}

resource "azurerm_cdn_frontdoor_origin" "this" {
  for_each = { for origin in var.origins : origin.name => origin }

  name                           = each.value.name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.this[each.value.origin_group_name].id
  host_name                      = each.value.host_name
  certificate_name_check_enabled = lookup(each.value, "certificate_name_check_enabled", true)
  enabled                        = lookup(each.value, "enabled", true)
  http_port                      = lookup(each.value, "http_port", 80)
  https_port                     = lookup(each.value, "https_port", 443)
  origin_host_header             = lookup(each.value, "origin_host_header", each.value.host_name)
  priority                       = lookup(each.value, "priority", 1)
  weight                         = lookup(each.value, "weight", 1000)

  dynamic "private_link" {
    for_each = lookup(each.value, "private_link", null) != null ? [each.value.private_link] : []
    content {
      request_message        = lookup(private_link.value, "request_message", null)
      target_type            = lookup(private_link.value, "target_type", null)
      location               = private_link.value.location
      private_link_target_id = private_link.value.private_link_target_id
    }
  }
}

resource "azurerm_cdn_frontdoor_route" "this" {
  for_each = { for route in var.routes : route.name => route }

  name                          = each.value.name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.this[each.value.endpoint_name].id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.this[each.value.origin_group_name].id
  cdn_frontdoor_origin_ids = [
    for origin in var.origins : azurerm_cdn_frontdoor_origin.this[origin.name].id
    if origin.origin_group_name == each.value.origin_group_name
  ]

  forwarding_protocol    = lookup(each.value, "forwarding_protocol", "HttpsOnly")
  https_redirect_enabled = lookup(each.value, "https_redirect_enabled", true)
  patterns_to_match      = each.value.patterns_to_match
  supported_protocols    = each.value.supported_protocols
  link_to_default_domain = lookup(each.value, "link_to_default_domain", true)
  enabled                = lookup(each.value, "enabled", true)

  dynamic "cache" {
    for_each = lookup(each.value, "cache", null) != null ? [each.value.cache] : []
    content {
      query_string_caching_behavior = lookup(cache.value, "query_string_caching_behavior", "IgnoreQueryString")
      query_strings                 = lookup(cache.value, "query_strings", null)
      compression_enabled           = lookup(cache.value, "compression_enabled", false)
      content_types_to_compress     = lookup(cache.value, "content_types_to_compress", null)
    }
  }
}

resource "azurerm_cdn_frontdoor_rule_set" "this" {
  for_each = { for rule_set in var.rule_sets : rule_set.name => rule_set }

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id
}

resource "azurerm_cdn_frontdoor_security_policy" "this" {
  for_each = { for policy in var.security_policies : policy.name => policy }

  name                     = each.value.name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.this.id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = each.value.firewall.cdn_frontdoor_firewall_policy_id

      association {
        patterns_to_match = each.value.firewall.association.patterns_to_match

        dynamic "domain" {
          for_each = each.value.firewall.association.endpoint_names
          content {
            cdn_frontdoor_domain_id = azurerm_cdn_frontdoor_endpoint.this[domain.value].id
          }
        }
      }
    }
  }
}
