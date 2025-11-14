variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "cluster_id" {
  description = "ECS cluster ID"
  type        = string
}

variable "task_family" {
  description = "Task definition family name"
  type        = string
}

variable "task_cpu" {
  description = "Task-level CPU units (required for awsvpc network mode)"
  type        = string
  default     = null
}

variable "task_memory" {
  description = "Task-level memory in MiB (required for awsvpc network mode)"
  type        = string
  default     = null
}

variable "container_definitions" {
  description = "Container definitions JSON"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the task execution role"
  type        = string
}

variable "task_role_arn" {
  description = "ARN of the IAM role for the task"
  type        = string
  default     = null
}

variable "network_mode" {
  description = "Network mode (bridge, host, awsvpc, none)"
  type        = string
  default     = "bridge"
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "subnets" {
  description = "List of subnet IDs (required for awsvpc mode)"
  type        = list(string)
  default     = []
}

variable "security_groups" {
  description = "List of security group IDs (required for awsvpc mode)"
  type        = list(string)
  default     = []
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks (awsvpc mode only)"
  type        = bool
  default     = false
}

variable "scheduling_strategy" {
  description = "Scheduling strategy (REPLICA or DAEMON)"
  type        = string
  default     = "REPLICA"
}

variable "enable_execute_command" {
  description = "Enable ECS Exec"
  type        = bool
  default     = false
}

variable "propagate_tags" {
  description = "Propagate tags from task definition or service"
  type        = string
  default     = "SERVICE"
}

variable "use_capacity_provider" {
  description = "Use capacity provider strategy instead of launch type"
  type        = bool
  default     = false
}

variable "capacity_provider_strategy" {
  description = "Capacity provider strategy for EC2"
  type = list(object({
    capacity_provider = string
    weight            = optional(number)
    base              = optional(number)
  }))
  default = []
}

variable "ordered_placement_strategy" {
  description = "Placement strategy for tasks"
  type = list(object({
    type  = string
    field = optional(string)
  }))
  default = [
    {
      type  = "spread"
      field = "attribute:ecs.availability-zone"
    },
    {
      type  = "spread"
      field = "instanceId"
    }
  ]
}

variable "placement_constraints" {
  description = "Placement constraints for the service"
  type = list(object({
    type       = string
    expression = optional(string)
  }))
  default = []
}

variable "task_placement_constraints" {
  description = "Placement constraints for the task definition"
  type = list(object({
    type       = string
    expression = optional(string)
  }))
  default = []
}

variable "load_balancer_config" {
  description = "Load balancer configuration"
  type = object({
    target_group_arn = string
    container_name   = string
    container_port   = number
  })
  default = null
}

variable "health_check_grace_period_seconds" {
  description = "Health check grace period in seconds"
  type        = number
  default     = 60
}

variable "service_registry_arn" {
  description = "ARN of the service registry (Cloud Map)"
  type        = string
  default     = null
}

variable "service_registry_container_name" {
  description = "Container name for service registry"
  type        = string
  default     = null
}

variable "service_registry_container_port" {
  description = "Container port for service registry"
  type        = number
  default     = null
}

variable "deployment_circuit_breaker_enabled" {
  description = "Enable deployment circuit breaker"
  type        = bool
  default     = true
}

variable "deployment_circuit_breaker_rollback" {
  description = "Enable automatic rollback on deployment failure"
  type        = bool
  default     = true
}

variable "deployment_controller_type" {
  description = "Deployment controller type (ECS, CODE_DEPLOY, EXTERNAL)"
  type        = string
  default     = "ECS"
}

variable "deployment_maximum_percent" {
  description = "Maximum percentage of tasks to run during deployment"
  type        = number
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "Minimum healthy percentage during deployment"
  type        = number
  default     = 100
}

variable "volumes" {
  description = "List of volumes for the task"
  type        = list(any)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
