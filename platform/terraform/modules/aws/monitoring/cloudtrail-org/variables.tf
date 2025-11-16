variable "name" {
  description = "Name of the CloudTrail"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket name for CloudTrail logs"
  type        = string
}

variable "is_organization_trail" {
  description = "Whether this is an organization trail"
  type        = bool
  default     = true
}

variable "is_multi_region_trail" {
  description = "Whether the trail is multi-region"
  type        = bool
  default     = true
}

variable "enable_log_file_validation" {
  description = "Enable log file validation"
  type        = bool
  default     = true
}

variable "include_global_service_events" {
  description = "Include global service events"
  type        = bool
  default     = true
}

variable "enable_logging" {
  description = "Enable logging"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for log encryption"
  type        = string
  default     = null
}

variable "cloud_watch_logs_group_arn" {
  description = "CloudWatch Logs group ARN"
  type        = string
  default     = null
}

variable "cloud_watch_logs_role_arn" {
  description = "CloudWatch Logs role ARN"
  type        = string
  default     = null
}

variable "event_selectors" {
  description = "Event selectors for the trail"
  type = list(object({
    read_write_type           = optional(string)
    include_management_events = optional(bool)
    data_resources = optional(list(object({
      type   = string
      values = list(string)
    })))
  }))
  default = []
}

variable "insight_selectors" {
  description = "Insight selectors for the trail"
  type = list(object({
    insight_type = string
  }))
  default = []
}

variable "s3_key_prefix" {
  description = "S3 key prefix for CloudTrail logs"
  type        = string
  default     = null
}

variable "sns_topic_name" {
  description = "SNS topic name for notifications"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
