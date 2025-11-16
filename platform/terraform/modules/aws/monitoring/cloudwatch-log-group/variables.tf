variable "name" {
  description = "Name of the CloudWatch Log Group"
  type        = string
}

variable "retention_in_days" {
  description = "Log retention in days"
  type        = number
  default     = 30
}

variable "kms_key_id" {
  description = "KMS key ID for log encryption"
  type        = string
  default     = null
}

variable "log_group_class" {
  description = "Log group class (STANDARD or INFREQUENT_ACCESS)"
  type        = string
  default     = "STANDARD"
}

variable "skip_destroy" {
  description = "Skip log group deletion on destroy"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
