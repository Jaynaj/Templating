variable "identifier" {
  description = "Database identifier"
  type        = string
}

variable "engine_edition" {
  description = "Oracle edition (ee, ee-cdb, se2, se2-cdb)"
  type        = string
  default     = "se2"

  validation {
    condition     = contains(["ee", "ee-cdb", "se2", "se2-cdb"], var.engine_edition)
    error_message = "Edition must be ee, ee-cdb, se2, or se2-cdb."
  }
}

variable "engine_version" {
  description = "Oracle engine version (e.g., 19.0.0.0.ru-2023-04.rur-2023-04.r1)"
  type        = string
}

variable "major_engine_version" {
  description = "Major engine version for option group (e.g., 19)"
  type        = string
}

variable "parameter_group_family" {
  description = "Parameter group family (e.g., oracle-ee-19, oracle-se2-19)"
  type        = string
}

variable "license_model" {
  description = "License model (license-included or bring-your-own-license)"
  type        = string
  default     = "license-included"

  validation {
    condition     = contains(["license-included", "bring-your-own-license"], var.license_model)
    error_message = "License model must be license-included or bring-your-own-license."
  }
}

variable "instance_class" {
  description = "Instance class (e.g., db.t3.medium, db.m5.large)"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 100
}

variable "storage_type" {
  description = "Storage type (gp2, gp3, io1, io2)"
  type        = string
  default     = "gp3"
}

variable "iops" {
  description = "IOPS for io1/io2 storage"
  type        = number
  default     = null
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

variable "db_name" {
  description = "Initial database name (SID for non-CDB, PDB name for CDB)"
  type        = string
  default     = "ORCL"
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
  default     = 1521
}

variable "db_subnet_group_name" {
  description = "DB subnet group name"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "List of VPC security group IDs"
  type        = list(string)
}

variable "publicly_accessible" {
  description = "Make database publicly accessible"
  type        = bool
  default     = false
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "availability_zone" {
  description = "Availability zone (for single-AZ deployments)"
  type        = string
  default     = null
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Backup window (e.g., 03:00-04:00)"
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
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

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to export to CloudWatch (alert, audit, trace, listener)"
  type        = list(string)
  default     = ["alert", "audit"]
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

variable "character_set_name" {
  description = "Character set name (e.g., AL32UTF8, WE8ISO8859P1)"
  type        = string
  default     = "AL32UTF8"
}

variable "nchar_character_set_name" {
  description = "National character set name (e.g., AL16UTF16, UTF8)"
  type        = string
  default     = "AL16UTF16"
}

variable "timezone" {
  description = "Database timezone (e.g., America/New_York, UTC)"
  type        = string
  default     = null
}

variable "option_group_name" {
  description = "Custom option group name (leave null to create default)"
  type        = string
  default     = null
}

variable "parameter_group_name" {
  description = "Custom parameter group name (leave null to create default)"
  type        = string
  default     = null
}

variable "options" {
  description = "List of option group options"
  type = list(object({
    option_name                    = string
    port                           = optional(number)
    version                        = optional(string)
    db_security_group_memberships  = optional(list(string))
    vpc_security_group_memberships = optional(list(string))
    option_settings = optional(list(object({
      name  = string
      value = string
    })))
  }))
  default = []
}

variable "parameters" {
  description = "List of database parameters"
  type = list(object({
    name         = string
    value        = string
    apply_method = optional(string)
  }))
  default = []
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

variable "auto_minor_version_upgrade" {
  description = "Enable automatic minor version upgrades"
  type        = bool
  default     = true
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrades"
  type        = bool
  default     = false
}

variable "apply_immediately" {
  description = "Apply changes immediately"
  type        = bool
  default     = false
}

variable "create_read_replica" {
  description = "Create read replica(s)"
  type        = bool
  default     = false
}

variable "read_replica_count" {
  description = "Number of read replicas"
  type        = number
  default     = 1
}

variable "replica_instance_class" {
  description = "Instance class for replicas (defaults to primary instance class)"
  type        = string
  default     = null
}

variable "replica_availability_zones" {
  description = "List of availability zones for replicas"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
