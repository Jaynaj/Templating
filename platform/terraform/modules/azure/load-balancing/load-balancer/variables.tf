variable "name" {
  description = "Name of the Load Balancer"
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
  description = "SKU (Basic, Standard, Gateway)"
  type        = string
  default     = "Standard"
}

variable "sku_tier" {
  description = "SKU tier (Regional, Global)"
  type        = string
  default     = "Regional"
}

variable "frontend_ip_configurations" {
  description = "Frontend IP configurations"
  type = list(object({
    name                          = string
    zones                         = optional(list(string))
    subnet_id                     = optional(string)
    private_ip_address            = optional(string)
    private_ip_address_allocation = optional(string)
    private_ip_address_version    = optional(string)
    public_ip_address_id          = optional(string)
  }))
}

variable "backend_address_pools" {
  description = "Backend address pool names"
  type        = list(string)
  default     = []
}

variable "probes" {
  description = "Health probes"
  type = list(object({
    name                = string
    protocol            = string
    port                = number
    request_path        = optional(string)
    interval_in_seconds = optional(number)
    number_of_probes    = optional(number)
  }))
  default = []
}

variable "load_balancing_rules" {
  description = "Load balancing rules"
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    backend_address_pool_name      = string
    probe_name                     = string
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    enable_floating_ip             = optional(bool)
    idle_timeout_in_minutes        = optional(number)
    load_distribution              = optional(string)
    disable_outbound_snat          = optional(bool)
    enable_tcp_reset               = optional(bool)
  }))
  default = []
}

variable "inbound_nat_rules" {
  description = "Inbound NAT rules"
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    protocol                       = string
    frontend_port                  = number
    backend_port                   = number
    enable_floating_ip             = optional(bool)
    idle_timeout_in_minutes        = optional(number)
    enable_tcp_reset               = optional(bool)
  }))
  default = []
}

variable "outbound_rules" {
  description = "Outbound rules (Standard SKU only)"
  type = list(object({
    name                     = string
    frontend_ip_configuration_names = list(string)
    backend_address_pool_name = string
    protocol                 = string
    allocated_outbound_ports = optional(number)
    idle_timeout_in_minutes  = optional(number)
    enable_tcp_reset         = optional(bool)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
