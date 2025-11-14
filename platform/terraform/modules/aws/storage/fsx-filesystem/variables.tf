variable "name" {
  description = "Name of the FSx file system"
  type        = string
}

variable "file_system_type" {
  description = "Type of FSx file system (LUSTRE, WINDOWS, ONTAP, OPENZFS)"
  type        = string

  validation {
    condition     = contains(["LUSTRE", "WINDOWS", "ONTAP", "OPENZFS"], var.file_system_type)
    error_message = "File system type must be LUSTRE, WINDOWS, ONTAP, or OPENZFS."
  }
}

variable "storage_capacity" {
  description = "Storage capacity in GiB"
  type        = number
}

variable "subnet_ids" {
  description = "List of subnet IDs (single AZ for most, multi-AZ for MULTI_AZ deployments)"
  type        = list(string)
}

variable "storage_type" {
  description = "Storage type (SSD or HDD)"
  type        = string
  default     = "SSD"
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

variable "kms_key_id" {
  description = "KMS key ID for encryption"
  type        = string
  default     = null
}

variable "automatic_backup_retention_days" {
  description = "Days to retain automatic backups (0 to disable)"
  type        = number
  default     = 7
}

variable "daily_automatic_backup_start_time" {
  description = "Time for daily backups in HH:MM format (UTC)"
  type        = string
  default     = null
}

variable "weekly_maintenance_start_time" {
  description = "Weekly maintenance window in d:HH:MM format (UTC)"
  type        = string
  default     = null
}

variable "copy_tags_to_backups" {
  description = "Copy tags to backups"
  type        = bool
  default     = true
}

# Lustre-specific variables
variable "lustre_deployment_type" {
  description = "Lustre deployment type (SCRATCH_1, SCRATCH_2, PERSISTENT_1, PERSISTENT_2)"
  type        = string
  default     = "PERSISTENT_2"
}

variable "per_unit_storage_throughput" {
  description = "Throughput per unit of storage in MB/s/TiB (for PERSISTENT)"
  type        = number
  default     = 200
}

variable "data_compression_type" {
  description = "Data compression type (NONE or LZ4)"
  type        = string
  default     = "LZ4"
}

variable "import_path" {
  description = "S3 path for Lustre import"
  type        = string
  default     = null
}

variable "export_path" {
  description = "S3 path for Lustre export"
  type        = string
  default     = null
}

variable "imported_file_chunk_size" {
  description = "Chunk size for imports in MiB"
  type        = number
  default     = 1024
}

variable "auto_import_policy" {
  description = "Auto-import policy (NEW, NEW_CHANGED, NEW_CHANGED_DELETED)"
  type        = string
  default     = null
}

variable "log_configuration" {
  description = "Lustre log configuration"
  type = object({
    destination = string
    level       = optional(string)
  })
  default = null
}

# Windows-specific variables
variable "windows_deployment_type" {
  description = "Windows deployment type (SINGLE_AZ_1, SINGLE_AZ_2, MULTI_AZ_1)"
  type        = string
  default     = "SINGLE_AZ_2"
}

variable "throughput_capacity" {
  description = "Throughput capacity in MB/s"
  type        = number
  default     = null
}

variable "preferred_subnet_id" {
  description = "Preferred subnet ID for multi-AZ deployments"
  type        = string
  default     = null
}

variable "active_directory_id" {
  description = "AWS Managed AD directory ID"
  type        = string
  default     = null
}

variable "self_managed_active_directory" {
  description = "Self-managed Active Directory configuration"
  type = object({
    dns_ips                                = list(string)
    domain_name                            = string
    password                               = string
    username                               = string
    file_system_administrators_group       = optional(string)
    organizational_unit_distinguished_name = optional(string)
  })
  default   = null
  sensitive = true
}

variable "skip_final_backup" {
  description = "Skip final backup when destroying (Windows only)"
  type        = bool
  default     = false
}

variable "aliases" {
  description = "DNS aliases for Windows file system"
  type        = list(string)
  default     = []
}

variable "audit_log_configuration" {
  description = "Audit log configuration for Windows"
  type = object({
    file_access_audit_log_level       = optional(string)
    file_share_access_audit_log_level = optional(string)
    audit_log_destination             = optional(string)
  })
  default = null
}

# ONTAP-specific variables
variable "ontap_deployment_type" {
  description = "ONTAP deployment type (SINGLE_AZ_1, MULTI_AZ_1)"
  type        = string
  default     = "SINGLE_AZ_1"
}

variable "endpoint_ip_address_range" {
  description = "IP address range for ONTAP endpoints (CIDR)"
  type        = string
  default     = null
}

variable "route_table_ids" {
  description = "Route table IDs for ONTAP multi-AZ"
  type        = list(string)
  default     = []
}

variable "fsx_admin_password" {
  description = "FSx admin password for ONTAP"
  type        = string
  default     = null
  sensitive   = true
}

variable "disk_iops_configuration" {
  description = "Disk IOPS configuration (for ONTAP and OpenZFS)"
  type = object({
    mode = optional(string)
    iops = optional(number)
  })
  default = null
}

# OpenZFS-specific variables
variable "openzfs_deployment_type" {
  description = "OpenZFS deployment type (SINGLE_AZ_1, SINGLE_AZ_2)"
  type        = string
  default     = "SINGLE_AZ_1"
}

variable "root_volume_configuration" {
  description = "Root volume configuration for OpenZFS"
  type = object({
    data_compression_type  = optional(string)
    copy_tags_to_snapshots = optional(bool)
    read_only              = optional(bool)
    record_size_kib        = optional(number)
    nfs_exports = optional(object({
      client_configurations = list(object({
        clients = list(string)
        options = list(string)
      }))
    }))
    user_and_group_quotas = optional(list(object({
      id                         = number
      storage_capacity_quota_gib = number
      type                       = string
    })))
  })
  default = null
}

variable "snapshot_id" {
  description = "Snapshot ID for restoring OpenZFS file system"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
