variable "name" {
  description = "Name of the Auto Scaling Group"
  type        = string
}

variable "min_size" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "capacity_rebalance" {
  description = "Enable capacity rebalancing for Spot instances"
  type        = bool
  default     = false
}

variable "default_cooldown" {
  description = "Default cooldown period in seconds"
  type        = number
  default     = 300
}

variable "health_check_grace_period" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 300
}

variable "health_check_type" {
  description = "Health check type (EC2 or ELB)"
  type        = string
  default     = "EC2"
}

variable "force_delete" {
  description = "Force delete ASG without waiting for instances to terminate"
  type        = bool
  default     = false
}

variable "termination_policies" {
  description = "List of termination policies"
  type        = list(string)
  default     = ["Default"]
}

variable "suspended_processes" {
  description = "List of suspended processes"
  type        = list(string)
  default     = []
}

variable "enabled_metrics" {
  description = "List of enabled metrics"
  type        = list(string)
  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
}

variable "metrics_granularity" {
  description = "Granularity for metrics collection"
  type        = string
  default     = "1Minute"
}

variable "wait_for_capacity_timeout" {
  description = "Timeout for waiting for capacity"
  type        = string
  default     = "10m"
}

variable "protect_from_scale_in" {
  description = "Protect instances from scale-in"
  type        = bool
  default     = false
}

variable "service_linked_role_arn" {
  description = "ARN of the service-linked role"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "launch_template" {
  description = "Launch template configuration"
  type = object({
    id      = optional(string)
    name    = optional(string)
    version = optional(string)
  })
  default = null
}

variable "mixed_instances_policy" {
  description = "Mixed instances policy configuration"
  type        = any
  default     = null
}

variable "initial_lifecycle_hooks" {
  description = "List of initial lifecycle hooks"
  type = list(object({
    name                    = string
    lifecycle_transition    = string
    default_result          = optional(string)
    heartbeat_timeout       = optional(number)
    notification_metadata   = optional(string)
    notification_target_arn = optional(string)
    role_arn                = optional(string)
  }))
  default = []
}

variable "target_group_arns" {
  description = "List of target group ARNs"
  type        = list(string)
  default     = []
}

variable "scaling_policies" {
  description = "Map of scaling policies"
  type        = any
  default     = {}
}

variable "scheduled_actions" {
  description = "Map of scheduled actions"
  type = map(object({
    min_size         = optional(number)
    max_size         = optional(number)
    desired_capacity = optional(number)
    start_time       = optional(string)
    end_time         = optional(string)
    recurrence       = optional(string)
    time_zone        = optional(string)
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
