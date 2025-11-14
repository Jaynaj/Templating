variable "name" {
  description = "Name of the EventBridge rule"
  type        = string
}

variable "description" {
  description = "Description of the rule"
  type        = string
  default     = ""
}

variable "event_pattern" {
  description = "Event pattern as JSON string"
  type        = string
  default     = null
}

variable "schedule_expression" {
  description = "Schedule expression for the rule"
  type        = string
  default     = null
}

variable "state" {
  description = "State of the rule (ENABLED or DISABLED)"
  type        = string
  default     = "ENABLED"
}

variable "role_arn" {
  description = "IAM role ARN for the rule"
  type        = string
  default     = null
}

variable "event_bus_name" {
  description = "Event bus name"
  type        = string
  default     = "default"
}

variable "targets" {
  description = "List of targets for the rule"
  type = list(object({
    arn      = string
    role_arn = optional(string)
    input    = optional(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
