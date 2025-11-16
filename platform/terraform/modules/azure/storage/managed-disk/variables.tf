variable "name" {
  description = "Name of the managed disk"
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

variable "storage_account_type" {
  description = "Storage account type (Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS, Premium_ZRS, StandardSSD_ZRS)"
  type        = string
}

variable "create_option" {
  description = "Create option (Empty, Copy, FromImage, Import, Restore)"
  type        = string
  default     = "Empty"
}

variable "disk_size_gb" {
  description = "Disk size in GB"
  type        = number
}

variable "source_resource_id" {
  description = "Source resource ID (for Copy or Restore)"
  type        = string
  default     = null
}

variable "source_uri" {
  description = "Source URI (for Import)"
  type        = string
  default     = null
}

variable "image_reference_id" {
  description = "Image reference ID (for FromImage)"
  type        = string
  default     = null
}

variable "zone" {
  description = "Availability zone"
  type        = string
  default     = null
}

variable "disk_encryption_set_id" {
  description = "Disk encryption set ID"
  type        = string
  default     = null
}

variable "network_access_policy" {
  description = "Network access policy (AllowAll, AllowPrivate, DenyAll)"
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "tier" {
  description = "Performance tier (for Premium SSD)"
  type        = string
  default     = null
}

variable "max_shares" {
  description = "Maximum number of VMs that can attach to the disk"
  type        = number
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
