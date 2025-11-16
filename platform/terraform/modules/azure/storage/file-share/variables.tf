variable "name" {
  description = "Name of the file share"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "quota" {
  description = "Quota in GB"
  type        = number
  default     = 5120
}

variable "enabled_protocol" {
  description = "Protocol (SMB or NFS)"
  type        = string
  default     = "SMB"
}

variable "access_tier" {
  description = "Access tier (TransactionOptimized, Hot, Cool, Premium)"
  type        = string
  default     = "TransactionOptimized"
}

variable "metadata" {
  description = "Metadata for the file share"
  type        = map(string)
  default     = {}
}
