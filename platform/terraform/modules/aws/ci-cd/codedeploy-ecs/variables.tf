variable "name" {
  description = "Name of the deployment group"
  type        = string
}

variable "app_name" {
  description = "Name of the CodeDeploy application"
  type        = string
}

variable "service_role_arn" {
  description = "IAM service role ARN for CodeDeploy"
  type        = string
}

variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "target_group_names" {
  description = "Names of target groups (blue and green)"
  type = object({
    blue  = string
    green = string
  })
}

variable "production_listener_arn" {
  description = "ARN of the production listener"
  type        = string
}

variable "test_listener_arn" {
  description = "ARN of the test listener (optional)"
  type        = string
  default     = null
}

variable "deployment_config_name" {
  description = "Deployment configuration name"
  type        = string
  default     = "CodeDeployDefault.ECSAllAtOnce"
}

variable "auto_rollback_enabled" {
  description = "Enable auto rollback"
  type        = bool
  default     = true
}

variable "auto_rollback_events" {
  description = "Events that trigger auto rollback"
  type        = list(string)
  default     = ["DEPLOYMENT_FAILURE", "DEPLOYMENT_STOP_ON_ALARM"]
}

variable "deployment_ready_option" {
  description = "Deployment ready option configuration"
  type = object({
    action_on_timeout    = optional(string)
    wait_time_in_minutes = optional(number)
  })
  default = null
}

variable "termination_wait_time_in_minutes" {
  description = "Time to wait before terminating original task set"
  type        = number
  default     = 5
}

variable "alarm_configuration" {
  description = "CloudWatch alarm configuration"
  type = object({
    enabled = bool
    alarms  = optional(list(string))
  })
  default = {
    enabled = false
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
