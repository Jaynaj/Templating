variable "name" {
  description = "Name/alias of the KMS key for RDS"
  type        = string
}

variable "description" {
  description = "Description of the KMS key"
  type        = string
  default     = "KMS key for RDS encryption"
}

variable "deletion_window_in_days" {
  description = "Duration in days before key deletion"
  type        = number
  default     = 30
}

variable "enable_key_rotation" {
  description = "Enable automatic key rotation"
  type        = bool
  default     = true
}

variable "multi_region" {
  description = "Create multi-region key for RDS global databases"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
