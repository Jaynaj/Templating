variable "name" {
  description = "Name of the ALB"
  type        = string
}

variable "internal" {
  description = "Whether the ALB is internal"
  type        = bool
  default     = false
}

variable "security_groups" {
  description = "Security group IDs"
  type        = list(string)
}

variable "subnets" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "enable_http2" {
  description = "Enable HTTP/2"
  type        = bool
  default     = true
}

variable "enable_waf_fail_open" {
  description = "Enable WAF fail open"
  type        = bool
  default     = false
}

variable "ip_address_type" {
  description = "IP address type (ipv4 or dualstack)"
  type        = string
  default     = "ipv4"
}

variable "drop_invalid_header_fields" {
  description = "Drop invalid HTTP header fields"
  type        = bool
  default     = true
}

variable "preserve_host_header" {
  description = "Preserve Host header"
  type        = bool
  default     = false
}

variable "enable_xff_client_port" {
  description = "Enable X-Forwarded-For client port"
  type        = bool
  default     = false
}

variable "xff_header_processing_mode" {
  description = "X-Forwarded-For header processing mode"
  type        = string
  default     = "append"
}

variable "idle_timeout" {
  description = "Connection idle timeout in seconds"
  type        = number
  default     = 60
}

variable "desync_mitigation_mode" {
  description = "Desync mitigation mode"
  type        = string
  default     = "defensive"
}

variable "access_logs" {
  description = "Access logs configuration"
  type = object({
    bucket  = string
    prefix  = optional(string)
    enabled = optional(bool)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
