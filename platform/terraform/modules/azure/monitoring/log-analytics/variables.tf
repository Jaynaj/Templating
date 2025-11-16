variable "name" {
  description = "Name of the Log Analytics Workspace"
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
  description = "SKU (Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, PerGB2018)"
  type        = string
  default     = "PerGB2018"
}

variable "retention_in_days" {
  description = "Retention in days"
  type        = number
  default     = 30
}

variable "daily_quota_gb" {
  description = "Daily quota in GB"
  type        = number
  default     = null
}

variable "internet_ingestion_enabled" {
  description = "Enable internet ingestion"
  type        = bool
  default     = true
}

variable "internet_query_enabled" {
  description = "Enable internet query"
  type        = bool
  default     = true
}

variable "reservation_capacity_in_gb_per_day" {
  description = "Reservation capacity in GB per day (for CapacityReservation SKU)"
  type        = number
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
