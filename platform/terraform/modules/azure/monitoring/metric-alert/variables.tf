variable "name" {
  description = "Name of the Metric Alert"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "scopes" {
  description = "List of resource IDs to monitor"
  type        = list(string)
}

variable "description" {
  description = "Description of the alert"
  type        = string
  default     = null
}

variable "enabled" {
  description = "Enable the alert"
  type        = bool
  default     = true
}

variable "auto_mitigate" {
  description = "Auto mitigate the alert"
  type        = bool
  default     = true
}

variable "frequency" {
  description = "Frequency of evaluation (PT1M, PT5M, PT15M, PT30M, PT1H)"
  type        = string
  default     = "PT1M"
}

variable "severity" {
  description = "Severity (0-4)"
  type        = number
  default     = 3
}

variable "window_size" {
  description = "Window size (PT1M, PT5M, PT15M, PT30M, PT1H, PT6H, PT12H, P1D)"
  type        = string
  default     = "PT5M"
}

variable "criteria" {
  description = "Criteria for the alert"
  type = list(object({
    metric_namespace = string
    metric_name      = string
    aggregation      = string
    operator         = string
    threshold        = number
    dimensions = optional(list(object({
      name     = string
      operator = string
      values   = list(string)
    })))
  }))
  default = []
}

variable "dynamic_criteria" {
  description = "Dynamic criteria for the alert"
  type = list(object({
    metric_namespace  = string
    metric_name       = string
    aggregation       = string
    operator          = string
    alert_sensitivity = string
    evaluation_total_count = optional(number)
    evaluation_failure_count = optional(number)
    dimensions = optional(list(object({
      name     = string
      operator = string
      values   = list(string)
    })))
  }))
  default = []
}

variable "action_group_ids" {
  description = "List of action group IDs"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
