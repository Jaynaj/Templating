variable "cluster_identifier" {
  description = "Cluster identifier"
  type        = string
}

variable "engine" {
  description = "Aurora engine (aurora-mysql)"
  type        = string
  default     = "aurora-mysql"
}

variable "engine_version" {
  description = "Aurora MySQL engine version (e.g., 8.0.mysql_aurora.3.04.0, 5.7.mysql_aurora.2.11.3)"
  type        = string
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
  default     = "admin"
}

variable "master_password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "db_subnet_group_name" {
  description = "DB subnet group name"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = []
}

variable "db_cluster_parameter_group_name" {
  description = "Custom cluster parameter group name (leave null to create default)"
  type        = string
  default     = null
}

variable "db_cluster_parameter_group_family" {
  description = "Cluster parameter group family (e.g., aurora-mysql8.0, aurora-mysql5.7)"
  type        = string
}

variable "db_parameter_group_name" {
  description = "Custom instance parameter group name (leave null to create default)"
  type        = string
  default     = null
}

variable "db_parameter_group_family" {
  description = "Instance parameter group family (e.g., aurora-mysql8.0, aurora-mysql5.7)"
  type        = string
}

variable "backup_retention_period" {
  description = "Backup retention period in days (1-35)"
  type        = number
  default     = 7
}

variable "preferred_backup_window" {
  description = "Backup window (e.g., 03:00-04:00)"
  type        = string
  default     = "03:00-04:00"
}

variable "preferred_maintenance_window" {
  description = "Maintenance window (e.g., mon:04:00-mon:05:00)"
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

variable "backtrack_window" {
  description = "Backtrack window in seconds (0 to 259200, MySQL 5.7 only)"
  type        = number
  default     = 0
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export (audit, error, general, slowquery)"
  type        = list(string)
  default     = ["audit", "error", "slowquery"]
}

variable "iam_database_authentication_enabled" {
  description = "Enable IAM database authentication"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "serverlessv2_scaling_configuration" {
  description = "Serverless v2 scaling configuration"
  type = object({
    min_capacity = number
    max_capacity = number
  })
  default = null
}

variable "global_cluster_identifier" {
  description = "Global cluster identifier for Aurora Global Database"
  type        = string
  default     = null
}

variable "snapshot_identifier" {
  description = "Snapshot ID to restore from"
  type        = string
  default     = null
}

variable "restore_to_point_in_time" {
  description = "Restore to point in time configuration"
  type = object({
    source_cluster_identifier  = string
    restore_type               = optional(string)
    use_latest_restorable_time = optional(bool)
    restore_to_time            = optional(string)
  })
  default = null
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

variable "cluster_parameters" {
  description = "List of cluster parameters"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string)
  }))
  default = []
}

variable "instance_parameters" {
  description = "List of instance parameters"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string)
  }))
  default = []
}

variable "instance_count" {
  description = "Number of cluster instances"
  type        = number
  default     = 2
}

variable "instance_class" {
  description = "Instance class (e.g., db.t3.medium, db.r5.large, db.serverless for Serverless v2)"
  type        = string
}

variable "performance_insights_enabled" {
  description = "Enable Performance Insights"
  type        = bool
  default     = true
}

variable "performance_insights_kms_key_id" {
  description = "KMS key ID for Performance Insights"
  type        = string
  default     = null
}

variable "performance_insights_retention_period" {
  description = "Performance Insights retention period in days (7, 731)"
  type        = number
  default     = 7
}

variable "monitoring_interval" {
  description = "Enhanced monitoring interval in seconds (0, 1, 5, 10, 15, 30, 60)"
  type        = number
  default     = 60
}

variable "monitoring_role_arn" {
  description = "IAM role ARN for enhanced monitoring"
  type        = string
  default     = null
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}

variable "publicly_accessible" {
  description = "Make instances publicly accessible"
  type        = bool
  default     = false
}

variable "instance_availability_zones" {
  description = "List of availability zones for instances"
  type        = list(string)
  default     = []
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

variable "autoscaling_metric_type" {
  description = "Metric type for auto-scaling (RDSReaderAverageCPUUtilization or RDSReaderAverageDatabaseConnections)"
  type        = string
  default     = "RDSReaderAverageCPUUtilization"
}

variable "autoscaling_target_value" {
  description = "Target value for the metric"
  type        = number
  default     = 70
}

variable "autoscaling_scale_in_cooldown" {
  description = "Scale-in cooldown period in seconds"
  type        = number
  default     = 300
}

variable "autoscaling_scale_out_cooldown" {
  description = "Scale-out cooldown period in seconds"
  type        = number
  default     = 300
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
