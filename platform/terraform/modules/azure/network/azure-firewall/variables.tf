variable "name" {
  description = "Name of the Azure Firewall"
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

variable "sku_name" {
  description = "SKU name of the Firewall"
  type        = string
  default     = "AZFW_VNet"
}

variable "sku_tier" {
  description = "SKU tier of the Firewall"
  type        = string
  default     = "Standard"
}

variable "ip_configuration" {
  description = "IP configuration for the Firewall"
  type = object({
    name                 = string
    subnet_id            = string
    public_ip_address_id = string
  })
}

variable "firewall_policy_id" {
  description = "ID of the Firewall Policy"
  type        = string
  default     = null
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = []
}

variable "threat_intel_mode" {
  description = "Threat intelligence mode (Off, Alert, Deny)"
  type        = string
  default     = "Alert"
}

variable "zones" {
  description = "Availability zones"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
