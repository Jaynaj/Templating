variable "identifier" {
  description = "DB instance identifier"
  type        = string
}

variable "engine_version" {
  description = "MySQL version"
  type        = string
  default     = "8.0.35"
}

variable "instance_class" {
  description = "Instance class"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1)"
  type        = string
  default     = "gp3"
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

variable "iops" {
  description = "IOPS for storage"
  type        = number
  default     = null
}

variable "storage_throughput" {
  description = "Storage throughput for gp3"
  type        = number
  default     = null
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = null
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "vpc_security_group_ids" {
  description = "VPC security group IDs"
  type        = list(string)
}

variable "db_subnet_group_name" {
  description = "DB subnet group name"
  type        = string
}

variable "publicly_accessible" {
  description = "Publicly accessible"
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "Availability zone for single-AZ deployment"
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Backup window"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  description = "Maintenance window"
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

variable "delete_automated_backups" {
  description = "Delete automated backups on deletion"
  type        = bool
  default     = true
}

variable "multi_az" {
  description = "Enable Multi-AZ"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "iam_database_authentication_enabled" {
  description = "Enable IAM database authentication"
  type        = bool
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  description = "CloudWatch log types to export"
  type        = list(string)
  default     = ["error", "general", "slowquery"]
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

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrade"
  type        = bool
  default     = false
}

variable "parameter_group_name" {
  description = "DB parameter group name"
  type        = string
  default     = null
}

variable "option_group_name" {
  description = "DB option group name"
  type        = string
  default     = null
}

variable "ca_cert_identifier" {
  description = "CA certificate identifier"
  type        = string
  default     = null
}

variable "restore_to_point_in_time" {
  description = "Restore to point in time configuration"
  type        = any
  default     = null
}

variable "create_read_replica" {
  description = "Create read replicas"
  type        = bool
  default     = false
}

variable "read_replica_count" {
  description = "Number of read replicas"
  type        = number
  default     = 1
}

variable "replica_instance_class" {
  description = "Instance class for replicas"
  type        = string
  default     = null
}

variable "replica_availability_zones" {
  description = "Availability zones for replicas"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
