variable "name" {
  description = "Name of the Application Insights"
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

variable "application_type" {
  description = "Application type (web, ios, other, java, MobileCenter, Node.JS, phone, store, web)"
  type        = string
  default     = "web"
}

variable "workspace_id" {
  description = "Log Analytics Workspace ID"
  type        = string
  default     = null
}

variable "retention_in_days" {
  description = "Retention in days"
  type        = number
  default     = 90
}

variable "daily_data_cap_in_gb" {
  description = "Daily data cap in GB"
  type        = number
  default     = null
}

variable "daily_data_cap_notifications_disabled" {
  description = "Disable daily data cap notifications"
  type        = bool
  default     = false
}

variable "sampling_percentage" {
  description = "Sampling percentage"
  type        = number
  default     = 100
}

variable "disable_ip_masking" {
  description = "Disable IP masking"
  type        = bool
  default     = false
}

variable "local_authentication_disabled" {
  description = "Disable local authentication"
  type        = bool
  default     = false
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

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
