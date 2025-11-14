variable "cluster_identifier" {
  description = "Aurora cluster identifier"
  type        = string
}

variable "engine_version" {
  description = "Aurora PostgreSQL version"
  type        = string
  default     = "15.4"
}

variable "engine_mode" {
  description = "Engine mode (provisioned, serverless, parallelquery, global)"
  type        = string
  default     = "provisioned"
}

variable "database_name" {
  description = "Initial database name"
  type        = string
  default     = null
}

variable "master_username" {
  description = "Master username"
  type        = string
}

variable "master_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "vpc_security_group_ids" {
  description = "VPC security group IDs"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "DB subnet group name"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = []
}

variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 2
}

variable "instance_class" {
  description = "Instance class"
  type        = string
  default     = "db.r6g.large"
}

variable "publicly_accessible" {
  description = "Publicly accessible"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "preferred_maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = "sun:04:00-sun:05:00"
}

variable "copy_tags_to_snapshot" {
  description = "Copy tags to snapshots"
  type        = bool
  default     = true
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on deletion"
  type        = bool
  default     = false
}

variable "storage_encrypted" {
  description = "Enable storage encryption"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

variable "iam_database_authentication_enabled" {
  description = "Enable IAM database authentication"
  type        = bool
  default     = true
}

variable "enabled_cloudwatch_logs_exports" {
  description = "CloudWatch log types to export"
  type        = list(string)
  default     = ["postgresql"]
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

variable "db_cluster_parameter_group_name" {
  description = "Cluster parameter group name"
  type        = string
  default     = null
}

variable "db_instance_parameter_group_name" {
  description = "Instance parameter group name"
  type        = string
  default     = null
}

variable "enable_http_endpoint" {
  description = "Enable HTTP endpoint (Data API)"
  type        = bool
  default     = false
}

variable "serverlessv2_scaling_configuration" {
  description = "Serverless v2 scaling configuration"
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default = null
}

variable "scaling_configuration" {
  description = "Serverless v1 scaling configuration"
  type        = any
  default     = null
}

variable "restore_to_point_in_time" {
  description = "Restore to point in time configuration"
  type        = any
  default     = null
}

variable "backtrack_window" {
  description = "Target backtrack window in seconds (0 to disable)"
  type        = number
  default     = 0
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval"
  type        = number
  default     = 60
}

variable "monitoring_role_arn" {
  description = "Monitoring role ARN"
  type        = string
  default     = null
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = true
}

variable "performance_insights_kms_key_id" {
  description = "KMS key for Performance Insights"
  type        = string
  default     = null
}

variable "performance_insights_retention_period" {
  description = "Performance Insights retention period"
  type        = number
  default     = 7
}

variable "auto_minor_version_upgrade" {
  description = "Auto minor version upgrade"
  type        = bool
  default     = true
}

variable "ca_cert_identifier" {
  description = "CA certificate identifier"
  type        = string
  default     = null
}

variable "enable_autoscaling" {
  description = "Enable auto-scaling for read replicas"
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Minimum number of read replicas"
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of read replicas"
  type        = number
  default     = 5
}

variable "autoscaling_target_cpu" {
  description = "Target CPU for auto-scaling"
  type        = number
  default     = 70
}

variable "autoscaling_scale_in_cooldown" {
  description = "Scale-in cooldown in seconds"
  type        = number
  default     = 300
}

variable "autoscaling_scale_out_cooldown" {
  description = "Scale-out cooldown in seconds"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
