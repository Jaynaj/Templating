variable "finding_publishing_frequency" {
  description = "Finding publishing frequency (FIFTEEN_MINUTES, ONE_HOUR, or SIX_HOURS)"
  type        = string
  default     = "SIX_HOURS"
}

variable "status" {
  description = "Status of Macie (ENABLED or PAUSED)"
  type        = string
  default     = "ENABLED"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
