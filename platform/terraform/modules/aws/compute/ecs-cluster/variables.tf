variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "container_insights_enabled" {
  description = "Enable CloudWatch Container Insights for the cluster"
  type        = bool
  default     = true
}

variable "enable_execute_command" {
  description = "Enable ECS Exec for debugging"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

variable "execute_command_logging" {
  description = "Logging configuration for ECS Exec (NONE, DEFAULT, OVERRIDE)"
  type        = string
  default     = "DEFAULT"
}

variable "execute_command_log_configuration" {
  description = "Log configuration for execute command"
  type        = map(string)
  default     = null
}

variable "capacity_providers" {
  description = "List of capacity providers to associate with the cluster"
  type        = list(string)
  default     = ["FARGATE", "FARGATE_SPOT"]
}

variable "default_capacity_provider_strategy" {
  description = "Default capacity provider strategy"
  type = list(object({
    capacity_provider = string
    weight            = optional(number)
    base              = optional(number)
  }))
  default = []
}

variable "create_cloudwatch_log_group" {
  description = "Create CloudWatch log group for Container Insights"
  type        = bool
  default     = true
}

variable "log_retention_in_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
