variable "name" {
  description = "Name of the SQL Server"
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

variable "version" {
  description = "SQL Server version"
  type        = string
  default     = "12.0"
}

variable "administrator_login" {
  description = "Administrator login"
  type        = string
}

variable "administrator_login_password" {
  description = "Administrator login password"
  type        = string
  sensitive   = true
}

variable "minimum_tls_version" {
  description = "Minimum TLS version"
  type        = string
  default     = "1.2"
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "azuread_administrator" {
  description = "Azure AD administrator configuration"
  type = object({
    login_username = string
    object_id      = string
  })
  default = null
}

variable "databases" {
  description = "Map of databases to create"
  type = map(object({
    collation                   = optional(string)
    sku_name                    = optional(string)
    max_size_gb                 = optional(number)
    zone_redundant              = optional(bool)
    read_scale                  = optional(bool)
    auto_pause_delay_in_minutes = optional(number)
    min_capacity                = optional(number)
  }))
  default = {}
}

variable "firewall_rules" {
  description = "Map of firewall rules"
  type = map(object({
    start_ip_address = string
    end_ip_address   = string
  }))
  default = {}
}

variable "identity" {
  description = "Managed identity configuration"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
