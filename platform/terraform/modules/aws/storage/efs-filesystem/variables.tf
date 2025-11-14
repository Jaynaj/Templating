variable "name" {
  description = "Name of the EFS file system"
  type        = string
}

variable "creation_token" {
  description = "Unique name for creation token (defaults to name)"
  type        = string
  default     = null
}

variable "encrypted" {
  description = "Enable encryption at rest"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "KMS key ID for encryption (uses default if not specified)"
  type        = string
  default     = null
}

variable "performance_mode" {
  description = "Performance mode (generalPurpose or maxIO)"
  type        = string
  default     = "generalPurpose"

  validation {
    condition     = contains(["generalPurpose", "maxIO"], var.performance_mode)
    error_message = "Performance mode must be generalPurpose or maxIO."
  }
}

variable "throughput_mode" {
  description = "Throughput mode (bursting, provisioned, or elastic)"
  type        = string
  default     = "bursting"

  validation {
    condition     = contains(["bursting", "provisioned", "elastic"], var.throughput_mode)
    error_message = "Throughput mode must be bursting, provisioned, or elastic."
  }
}

variable "provisioned_throughput_in_mibps" {
  description = "Provisioned throughput in MiB/s (only for provisioned mode)"
  type        = number
  default     = null
}

variable "transition_to_ia" {
  description = "Lifecycle policy to transition to IA (AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS, AFTER_90_DAYS)"
  type        = string
  default     = "AFTER_30_DAYS"
}

variable "transition_to_primary_storage_class" {
  description = "Lifecycle policy to transition back to primary storage (AFTER_1_ACCESS)"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for mount targets (typically one per AZ)"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for mount targets"
  type        = list(string)
}

variable "mount_target_ip_addresses" {
  description = "Optional list of IP addresses for mount targets"
  type        = list(string)
  default     = []
}

variable "access_points" {
  description = "Map of access points to create"
  type = map(object({
    posix_user = object({
      gid            = number
      uid            = number
      secondary_gids = optional(list(number))
    })
    root_directory = object({
      path = string
      creation_info = optional(object({
        owner_gid   = number
        owner_uid   = number
        permissions = string
      }))
    })
  }))
  default = {}
}

variable "file_system_policy" {
  description = "EFS file system policy JSON"
  type        = string
  default     = null
}

variable "enable_backup_policy" {
  description = "Enable automatic backups"
  type        = bool
  default     = true
}

variable "replication_configuration" {
  description = "Replication configuration for disaster recovery"
  type = object({
    region                 = string
    availability_zone_name = optional(string)
    kms_key_id             = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
