variable "alarms" {
  description = "Map of CloudWatch metric alarms"
  type = map(object({
    comparison_operator = string
    evaluation_periods  = number
    metric_name         = string
    namespace           = string
    period              = number
    statistic           = string
    threshold           = number
    alarm_description   = optional(string)
    alarm_actions       = optional(list(string))
    ok_actions          = optional(list(string))
    insufficient_data_actions = optional(list(string))
    datapoints_to_alarm = optional(number)
    treat_missing_data  = optional(string)
    dimensions          = optional(map(string))
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
