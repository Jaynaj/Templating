variable "name" {
  description = "Name of the Redis Cache"
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

variable "capacity" {
  description = "Capacity (size) of the Redis cache"
  type        = number
}

variable "family" {
  description = "SKU family (C or P)"
  type        = string
}

variable "sku_name" {
  description = "SKU name (Basic, Standard, Premium)"
  type        = string
}

variable "enable_non_ssl_port" {
  description = "Enable non-SSL port"
  type        = bool
  default     = false
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

variable "redis_configuration" {
  description = "Redis configuration"
  type = object({
    maxmemory_policy                     = optional(string)
    maxmemory_reserved                   = optional(number)
    maxfragmentationmemory_reserved      = optional(number)
    maxmemory_delta                      = optional(number)
    rdb_backup_enabled                   = optional(bool)
    rdb_backup_frequency                 = optional(number)
    rdb_backup_max_snapshot_count        = optional(number)
    rdb_storage_connection_string        = optional(string)
    aof_backup_enabled                   = optional(bool)
    aof_storage_connection_string_0      = optional(string)
    aof_storage_connection_string_1      = optional(string)
    enable_authentication                = optional(bool)
  })
  default = null
}

variable "subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
  default     = null
}

variable "private_static_ip_address" {
  description = "Private static IP address"
  type        = string
  default     = null
}

variable "zones" {
  description = "Availability zones"
  type        = list(string)
  default     = []
}

variable "replicas_per_master" {
  description = "Number of replicas per master"
  type        = number
  default     = null
}

variable "replicas_per_primary" {
  description = "Number of replicas per primary"
  type        = number
  default     = null
}

variable "shard_count" {
  description = "Shard count for Premium SKU"
  type        = number
  default     = null
}

variable "patch_schedule" {
  description = "Patch schedule configuration"
  type = list(object({
    day_of_week        = string
    start_hour_utc     = optional(number)
    maintenance_window = optional(string)
  }))
  default = []
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
