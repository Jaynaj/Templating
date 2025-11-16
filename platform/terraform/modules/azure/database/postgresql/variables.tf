variable "name" {
  description = "Name of the PostgreSQL Server"
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
  description = "SKU name"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_mb" {
  description = "Storage size in MB"
  type        = number
  default     = 32768
}

variable "version" {
  description = "PostgreSQL version"
  type        = string
  default     = "13"
}

variable "administrator_login" {
  description = "Administrator login"
  type        = string
}

variable "administrator_password" {
  description = "Administrator password"
  type        = string
  sensitive   = true
}

variable "backup_retention_days" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "geo_redundant_backup_enabled" {
  description = "Enable geo-redundant backup"
  type        = bool
  default     = false
}

variable "auto_grow_enabled" {
  description = "Enable auto grow"
  type        = bool
  default     = true
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "ssl_enforcement_enabled" {
  description = "Enable SSL enforcement"
  type        = bool
  default     = true
}

variable "ssl_minimal_tls_version_enforced" {
  description = "Minimum TLS version"
  type        = string
  default     = "TLS1_2"
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = null
}

variable "high_availability" {
  description = "High availability configuration"
  type = object({
    mode                      = string
    standby_availability_zone = optional(string)
  })
  default = null
}

variable "databases" {
  description = "Map of databases to create"
  type = map(object({
    charset   = optional(string)
    collation = optional(string)
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

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
