variable "name" {
  description = "Name of the MySQL Server"
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

variable "storage" {
  description = "Storage configuration"
  type = object({
    size_gb           = number
    iops              = optional(number)
    auto_grow_enabled = optional(bool)
  })
  default = {
    size_gb           = 20
    auto_grow_enabled = true
  }
}

variable "version" {
  description = "MySQL version"
  type        = string
  default     = "8.0.21"
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
