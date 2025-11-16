variable "name" {
  description = "Name of the blob container"
  type        = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type        = string
}

variable "container_access_type" {
  description = "Container access type (private, blob, container)"
  type        = string
  default     = "private"
}

variable "metadata" {
  description = "Metadata for the container"
  type        = map(string)
  default     = {}
}
