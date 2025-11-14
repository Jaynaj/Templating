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

variable "cpu" {
  description = "CPU units for the task (256, 512, 1024, 2048, 4096)"
  type        = string
  default     = "256"
}

variable "memory" {
  description = "Memory for the task in MiB"
  type        = string
  default     = "512"
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

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "subnets" {
  description = "List of subnet IDs for the service"
  type        = list(string)
}

variable "security_groups" {
  description = "List of security group IDs"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP to tasks"
  type        = bool
  default     = false
}

variable "platform_version" {
  description = "Fargate platform version"
  type        = string
  default     = "LATEST"
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
  default     = true
}

variable "capacity_provider_strategy" {
  description = "Capacity provider strategy"
  type = list(object({
    capacity_provider = string
    weight            = optional(number)
    base              = optional(number)
  }))
  default = [
    {
      capacity_provider = "FARGATE_SPOT"
      weight            = 1
      base              = 0
    }
  ]
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

variable "volumes" {
  description = "List of volumes for the task"
  type        = list(any)
  default     = []
}

variable "operating_system_family" {
  description = "Operating system family (LINUX or WINDOWS_SERVER_2019_FULL, etc.)"
  type        = string
  default     = "LINUX"
}

variable "cpu_architecture" {
  description = "CPU architecture (X86_64 or ARM64)"
  type        = string
  default     = "X86_64"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
