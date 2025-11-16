variable "name" {
  description = "Name of the Container Registry"
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
  description = "SKU (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Enable admin user"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "zone_redundancy_enabled" {
  description = "Enable zone redundancy (Premium SKU only)"
  type        = bool
  default     = false
}

variable "export_policy_enabled" {
  description = "Enable export policy (Premium SKU only)"
  type        = bool
  default     = true
}

variable "quarantine_policy_enabled" {
  description = "Enable quarantine policy (Premium SKU only)"
  type        = bool
  default     = false
}

variable "retention_policy" {
  description = "Retention policy (Premium SKU only)"
  type = object({
    days    = number
    enabled = bool
  })
  default = null
}

variable "trust_policy" {
  description = "Trust policy (Premium SKU only)"
  type = object({
    enabled = bool
  })
  default = null
}

variable "georeplications" {
  description = "Geo-replication locations (Premium SKU only)"
  type = list(object({
    location                  = string
    zone_redundancy_enabled   = optional(bool)
    regional_endpoint_enabled = optional(bool)
  }))
  default = []
}

variable "network_rule_set" {
  description = "Network rule set (Premium SKU only)"
  type = object({
    default_action = string
    ip_rule = optional(list(object({
      action   = string
      ip_range = string
    })))
    virtual_network = optional(list(object({
      action    = string
      subnet_id = string
    })))
  })
  default = null
}

variable "identity" {
  description = "Managed identity configuration"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "encryption" {
  description = "Encryption configuration (Premium SKU only)"
  type = object({
    enabled            = bool
    key_vault_key_id   = optional(string)
    identity_client_id = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
