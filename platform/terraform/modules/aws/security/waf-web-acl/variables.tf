variable "name" {
  description = "Name of the WAF Web ACL"
  type        = string
}

variable "description" {
  description = "Description of the WAF Web ACL"
  type        = string
  default     = ""
}

variable "scope" {
  description = "Scope of the WAF Web ACL (REGIONAL or CLOUDFRONT)"
  type        = string
  default     = "REGIONAL"
}

variable "default_action" {
  description = "Default action (allow or block)"
  type        = string
  default     = "allow"
}

variable "rules" {
  description = "List of WAF rules"
  type = list(object({
    name     = string
    priority = number
    action   = string
    statement = any
    visibility_config = object({
      cloudwatch_metrics_enabled = bool
      metric_name                = string
      sampled_requests_enabled   = bool
    })
  }))
  default = []
}

variable "cloudwatch_metrics_enabled" {
  description = "Enable CloudWatch metrics"
  type        = bool
  default     = true
}

variable "sampled_requests_enabled" {
  description = "Enable sampled requests"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
