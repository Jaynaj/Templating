variable "name" {
  description = "Name of the VPN Gateway"
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

variable "type" {
  description = "Type of the Virtual Network Gateway (Vpn or ExpressRoute)"
  type        = string
  default     = "Vpn"
}

variable "vpn_type" {
  description = "VPN type (RouteBased or PolicyBased)"
  type        = string
  default     = "RouteBased"
}

variable "sku" {
  description = "SKU of the VPN Gateway"
  type        = string
  default     = "VpnGw1"
}

variable "generation" {
  description = "Generation of the VPN Gateway"
  type        = string
  default     = "Generation1"
}

variable "enable_bgp" {
  description = "Enable BGP"
  type        = bool
  default     = false
}

variable "active_active" {
  description = "Enable active-active mode"
  type        = bool
  default     = false
}

variable "ip_configuration" {
  description = "IP configuration for the VPN Gateway"
  type = object({
    name                          = string
    public_ip_address_id          = string
    private_ip_address_allocation = optional(string)
    subnet_id                     = string
  })
}

variable "secondary_ip_configuration" {
  description = "Secondary IP configuration for active-active mode"
  type = object({
    name                          = string
    public_ip_address_id          = string
    private_ip_address_allocation = optional(string)
    subnet_id                     = string
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
