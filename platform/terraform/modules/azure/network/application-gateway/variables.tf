variable "name" {
  description = "Name of the Application Gateway"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "sku" {
  description = "SKU configuration"
  type = object({
    name     = string
    tier     = string
    capacity = optional(number)
  })
}

variable "gateway_ip_configuration" {
  description = "Gateway IP configuration"
  type = object({
    name      = string
    subnet_id = string
  })
}

variable "frontend_ip_configurations" {
  description = "Frontend IP configurations"
  type = list(object({
    name                          = string
    subnet_id                     = optional(string)
    private_ip_address            = optional(string)
    private_ip_address_allocation = optional(string)
    public_ip_address_id          = optional(string)
  }))
}

variable "frontend_ports" {
  description = "Frontend ports"
  type = list(object({
    name = string
    port = number
  }))
}

variable "backend_address_pools" {
  description = "Backend address pools"
  type = list(object({
    name         = string
    fqdns        = optional(list(string))
    ip_addresses = optional(list(string))
  }))
}

variable "backend_http_settings" {
  description = "Backend HTTP settings"
  type = list(object({
    name                                = string
    cookie_based_affinity               = string
    port                                = number
    protocol                            = string
    request_timeout                     = optional(number)
    probe_name                          = optional(string)
    pick_host_name_from_backend_address = optional(bool)
  }))
}

variable "http_listeners" {
  description = "HTTP listeners"
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    ssl_certificate_name           = optional(string)
    host_name                      = optional(string)
  }))
}

variable "request_routing_rules" {
  description = "Request routing rules"
  type = list(object({
    name                       = string
    rule_type                  = string
    http_listener_name         = string
    backend_address_pool_name  = optional(string)
    backend_http_settings_name = optional(string)
    priority                   = number
  }))
}

variable "ssl_certificates" {
  description = "SSL certificates"
  type = list(object({
    name     = string
    data     = optional(string)
    password = optional(string)
  }))
  default = []
}

variable "probes" {
  description = "Health probes"
  type = list(object({
    name                                      = string
    protocol                                  = string
    path                                      = string
    interval                                  = number
    timeout                                   = number
    unhealthy_threshold                       = number
    pick_host_name_from_backend_http_settings = optional(bool)
    host                                      = optional(string)
  }))
  default = []
}

variable "enable_http2" {
  description = "Enable HTTP2"
  type        = bool
  default     = false
}

variable "waf_configuration" {
  description = "WAF configuration"
  type = object({
    enabled          = bool
    firewall_mode    = string
    rule_set_type    = string
    rule_set_version = string
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
