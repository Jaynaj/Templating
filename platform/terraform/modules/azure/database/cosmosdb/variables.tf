variable "name" {
  description = "Name of the Cosmos DB Account"
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

variable "offer_type" {
  description = "Offer type (Standard)"
  type        = string
  default     = "Standard"
}

variable "kind" {
  description = "Kind of Cosmos DB (GlobalDocumentDB, MongoDB, Parse)"
  type        = string
  default     = "GlobalDocumentDB"
}

variable "consistency_policy" {
  description = "Consistency policy configuration"
  type = object({
    consistency_level       = string
    max_interval_in_seconds = optional(number)
    max_staleness_prefix    = optional(number)
  })
  default = {
    consistency_level = "Session"
  }
}

variable "geo_locations" {
  description = "Geo locations for replication"
  type = list(object({
    location          = string
    failover_priority = number
    zone_redundant    = optional(bool)
  }))
}

variable "enable_automatic_failover" {
  description = "Enable automatic failover"
  type        = bool
  default     = false
}

variable "enable_multiple_write_locations" {
  description = "Enable multiple write locations"
  type        = bool
  default     = false
}

variable "enable_free_tier" {
  description = "Enable free tier"
  type        = bool
  default     = false
}

variable "analytical_storage_enabled" {
  description = "Enable analytical storage"
  type        = bool
  default     = false
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "ip_range_filter" {
  description = "IP range filter"
  type        = string
  default     = null
}

variable "capabilities" {
  description = "List of capabilities (EnableAggregationPipeline, EnableCassandra, EnableGremlin, EnableTable, EnableServerless, MongoDBv3.4, mongoEnableDocLevelTTL)"
  type        = list(string)
  default     = []
}

variable "virtual_network_rules" {
  description = "List of virtual network subnet IDs"
  type        = list(string)
  default     = []
}

variable "backup" {
  description = "Backup configuration"
  type = object({
    type                = string
    interval_in_minutes = optional(number)
    retention_in_hours  = optional(number)
    storage_redundancy  = optional(string)
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

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
