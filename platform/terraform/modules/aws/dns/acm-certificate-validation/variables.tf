variable "certificate_arn" {
  description = "ARN of the certificate to validate"
  type        = string
}

variable "validation_record_fqdns" {
  description = "List of FQDNs for validation records"
  type        = list(string)
  default     = []
}

variable "validation_timeout" {
  description = "Timeout for validation (e.g., 45m)"
  type        = string
  default     = "45m"
}
