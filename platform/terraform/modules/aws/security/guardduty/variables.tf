variable "enable" {
  description = "Enable GuardDuty"
  type        = bool
  default     = true
}

variable "finding_publishing_frequency" {
  description = "Frequency of notifications (FIFTEEN_MINUTES, ONE_HOUR, or SIX_HOURS)"
  type        = string
  default     = "SIX_HOURS"
}

variable "enable_s3_protection" {
  description = "Enable S3 protection"
  type        = bool
  default     = true
}

variable "enable_kubernetes_protection" {
  description = "Enable Kubernetes protection"
  type        = bool
  default     = true
}

variable "enable_malware_protection" {
  description = "Enable Malware protection"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
