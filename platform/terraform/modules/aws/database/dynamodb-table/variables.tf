variable "name" {
  description = "Name of the DynamoDB table"
  type        = string
}

variable "billing_mode" {
  description = "Billing mode (PROVISIONED or PAY_PER_REQUEST)"
  type        = string
  default     = "PAY_PER_REQUEST"
}

variable "read_capacity" {
  description = "Read capacity units"
  type        = number
  default     = 5
}

variable "write_capacity" {
  description = "Write capacity units"
  type        = number
  default     = 5
}

variable "hash_key" {
  description = "Hash key attribute name"
  type        = string
}

variable "range_key" {
  description = "Range key attribute name"
  type        = string
  default     = null
}

variable "attributes" {
  description = "List of attribute definitions"
  type = list(object({
    name = string
    type = string
  }))
}

variable "global_secondary_indexes" {
  description = "List of GSI definitions"
  type        = list(any)
  default     = []
}

variable "local_secondary_indexes" {
  description = "List of LSI definitions"
  type        = list(any)
  default     = []
}

variable "ttl_enabled" {
  description = "Enable TTL"
  type        = bool
  default     = false
}

variable "ttl_attribute_name" {
  description = "TTL attribute name"
  type        = string
  default     = "ttl"
}

variable "server_side_encryption_enabled" {
  description = "Enable server-side encryption"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "KMS key ARN for encryption"
  type        = string
  default     = null
}

variable "point_in_time_recovery_enabled" {
  description = "Enable point-in-time recovery"
  type        = bool
  default     = true
}

variable "stream_enabled" {
  description = "Enable DynamoDB Streams"
  type        = bool
  default     = false
}

variable "stream_view_type" {
  description = "Stream view type"
  type        = string
  default     = "NEW_AND_OLD_IMAGES"
}

variable "enable_autoscaling" {
  description = "Enable auto-scaling"
  type        = bool
  default     = false
}

variable "autoscaling_read_max_capacity" {
  description = "Max read capacity for auto-scaling"
  type        = number
  default     = 100
}

variable "autoscaling_read_target_value" {
  description = "Target utilization for read auto-scaling"
  type        = number
  default     = 70
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
