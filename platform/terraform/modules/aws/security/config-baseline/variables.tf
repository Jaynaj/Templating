variable "name" {
  description = "Name of the Config recorder"
  type        = string
}

variable "s3_bucket_name" {
  description = "S3 bucket for Config"
  type        = string
}

variable "s3_key_prefix" {
  description = "S3 key prefix"
  type        = string
  default     = "config"
}

variable "delivery_frequency" {
  description = "Delivery frequency (One_Hour, Three_Hours, Six_Hours, Twelve_Hours, or TwentyFour_Hours)"
  type        = string
  default     = "TwentyFour_Hours"
}

variable "iam_role_arn" {
  description = "IAM role ARN for Config"
  type        = string
}

variable "sns_topic_arn" {
  description = "SNS topic ARN for notifications"
  type        = string
  default     = null
}

variable "include_global_resource_types" {
  description = "Include global resource types"
  type        = bool
  default     = true
}

variable "resource_types" {
  description = "List of resource types to record"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
