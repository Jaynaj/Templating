variable "name" {
  description = "Name of the composite alarm"
  type        = string
}

variable "alarm_description" {
  description = "Description of the alarm"
  type        = string
  default     = ""
}

variable "alarm_rule" {
  description = "Expression that specifies which other alarms are used to determine this composite alarm's state"
  type        = string
}

variable "actions_enabled" {
  description = "Enable actions for the alarm"
  type        = bool
  default     = true
}

variable "alarm_actions" {
  description = "List of ARNs to notify when alarm enters ALARM state"
  type        = list(string)
  default     = []
}

variable "ok_actions" {
  description = "List of ARNs to notify when alarm enters OK state"
  type        = list(string)
  default     = []
}

variable "insufficient_data_actions" {
  description = "List of ARNs to notify when alarm enters INSUFFICIENT_DATA state"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
