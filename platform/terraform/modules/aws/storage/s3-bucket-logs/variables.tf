variable "bucket_name" {
  description = "Name of the S3 bucket for logs"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket to be destroyed even if it contains objects"
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "kms_master_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

variable "bucket_key_enabled" {
  description = "Enable S3 Bucket Keys for SSE-KMS"
  type        = bool
  default     = true
}

variable "transition_to_ia_days" {
  description = "Days until transition to STANDARD_IA"
  type        = number
  default     = 30
}

variable "transition_to_glacier_days" {
  description = "Days until transition to GLACIER"
  type        = number
  default     = 90
}

variable "transition_to_deep_archive_days" {
  description = "Days until transition to DEEP_ARCHIVE"
  type        = number
  default     = 180
}

variable "expiration_days" {
  description = "Days until object expiration"
  type        = number
  default     = 365
}

variable "enable_intelligent_tiering" {
  description = "Enable Intelligent-Tiering for cost optimization"
  type        = bool
  default     = false
}

variable "allow_elb_logging" {
  description = "Allow ELB/ALB to write logs"
  type        = bool
  default     = true
}

variable "allow_cloudfront_logging" {
  description = "Allow CloudFront to write logs"
  type        = bool
  default     = false
}

variable "bucket_policy" {
  description = "Custom bucket policy (overrides default)"
  type        = string
  default     = null
}

variable "enable_object_lock" {
  description = "Enable object lock for compliance"
  type        = bool
  default     = false
}

variable "object_lock_mode" {
  description = "Object lock mode (GOVERNANCE or COMPLIANCE)"
  type        = string
  default     = "GOVERNANCE"
}

variable "object_lock_days" {
  description = "Object lock retention days"
  type        = number
  default     = 365
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
