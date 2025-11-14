variable "replication_group_id" {
  description = "Replication group identifier"
  type        = string
}

variable "description" {
  description = "Description of the replication group"
  type        = string
  default     = "Managed by Terraform"
}

variable "engine_version" {
  description = "Redis version"
  type        = string
  default     = "7.0"
}

variable "node_type" {
  description = "Instance node type"
  type        = string
}

variable "num_cache_clusters" {
  description = "Number of cache clusters (nodes) - use for non-cluster mode"
  type        = number
  default     = 2
}

variable "port" {
  description = "Port number"
  type        = number
  default     = 6379
}

variable "parameter_group_name" {
  description = "Parameter group name"
  type        = string
  default     = null
}

variable "subnet_group_name" {
  description = "Subnet group name"
  type        = string
  default     = null
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}

variable "automatic_failover_enabled" {
  description = "Enable automatic failover"
  type        = bool
  default     = true
}

variable "multi_az_enabled" {
  description = "Enable Multi-AZ"
  type        = bool
  default     = true
}

variable "at_rest_encryption_enabled" {
  description = "Enable encryption at rest"
  type        = bool
  default     = true
}

variable "transit_encryption_enabled" {
  description = "Enable encryption in transit"
  type        = bool
  default     = true
}

variable "auth_token_enabled" {
  description = "Enable auth token (password)"
  type        = bool
  default     = true
}

variable "auth_token" {
  description = "Auth token for Redis AUTH"
  type        = string
  sensitive   = true
  default     = null
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

variable "snapshot_retention_limit" {
  description = "Number of days to retain backups"
  type        = number
  default     = 7
}

variable "snapshot_window" {
  description = "Daily time range for backups"
  type        = string
  default     = "03:00-05:00"
}

variable "maintenance_window" {
  description = "Weekly maintenance window"
  type        = string
  default     = "sun:05:00-sun:07:00"
}

variable "notification_topic_arn" {
  description = "SNS topic ARN for notifications"
  type        = string
  default     = null
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

variable "data_tiering_enabled" {
  description = "Enable data tiering (r6gd nodes)"
  type        = bool
  default     = false
}

variable "log_delivery_configuration" {
  description = "Log delivery configurations"
  type        = list(any)
  default     = []
}

variable "cluster_mode_enabled" {
  description = "Enable cluster mode (sharding)"
  type        = bool
  default     = false
}

variable "cluster_mode" {
  description = "Cluster mode configuration"
  type = object({
    num_node_groups         = number
    replicas_per_node_group = number
  })
  default = {
    num_node_groups         = 2
    replicas_per_node_group = 1
  }
}

variable "user_group_ids" {
  description = "User group IDs for RBAC"
  type        = list(string)
  default     = []
}

variable "create_subnet_group" {
  description = "Create a new subnet group"
  type        = bool
  default     = false
}

variable "subnet_ids" {
  description = "Subnet IDs for subnet group"
  type        = list(string)
  default     = []
}

variable "create_parameter_group" {
  description = "Create a new parameter group"
  type        = bool
  default     = false
}

variable "parameter_group_family" {
  description = "Parameter group family"
  type        = string
  default     = "redis7"
}

variable "parameters" {
  description = "List of parameters"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
