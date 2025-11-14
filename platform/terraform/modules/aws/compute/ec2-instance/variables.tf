variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for the instance"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t3.micro"
}

variable "availability_zone" {
  description = "Availability zone for the instance"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID for the instance"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  default     = []
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
  default     = null
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Associate a public IP address"
  type        = bool
  default     = false
}

variable "private_ip" {
  description = "Private IP address"
  type        = string
  default     = null
}

variable "source_dest_check" {
  description = "Enable source/destination checking"
  type        = bool
  default     = true
}

variable "user_data" {
  description = "User data script"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Base64-encoded user data"
  type        = string
  default     = null
}

variable "user_data_replace_on_change" {
  description = "Replace instance when user data changes"
  type        = bool
  default     = false
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = false
}

variable "ebs_optimized" {
  description = "Enable EBS optimization"
  type        = bool
  default     = null
}

variable "disable_api_termination" {
  description = "Enable termination protection"
  type        = bool
  default     = false
}

variable "disable_api_stop" {
  description = "Disable stop via API"
  type        = bool
  default     = false
}

variable "instance_initiated_shutdown_behavior" {
  description = "Shutdown behavior (stop or terminate)"
  type        = string
  default     = "stop"
}

variable "cpu_core_count" {
  description = "Number of CPU cores"
  type        = number
  default     = null
}

variable "cpu_threads_per_core" {
  description = "Number of threads per CPU core"
  type        = number
  default     = null
}

variable "cpu_credits" {
  description = "CPU credit option for burstable instances (standard or unlimited)"
  type        = string
  default     = null
}

variable "root_block_device" {
  description = "Root block device configuration"
  type = object({
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    kms_key_id            = optional(string)
    throughput            = optional(number)
    volume_size           = optional(number)
    volume_type           = optional(string)
    tags                  = optional(map(string))
  })
  default = null
}

variable "ebs_block_devices" {
  description = "Additional EBS block devices"
  type = list(object({
    device_name           = string
    delete_on_termination = optional(bool)
    encrypted             = optional(bool)
    iops                  = optional(number)
    kms_key_id            = optional(string)
    snapshot_id           = optional(string)
    throughput            = optional(number)
    volume_size           = optional(number)
    volume_type           = optional(string)
    tags                  = optional(map(string))
  }))
  default = []
}

variable "ephemeral_block_devices" {
  description = "Ephemeral block devices (instance store)"
  type = list(object({
    device_name  = string
    virtual_name = string
  }))
  default = []
}

variable "metadata_options" {
  description = "Instance metadata options"
  type = object({
    http_endpoint               = optional(string)
    http_tokens                 = optional(string)
    http_put_response_hop_limit = optional(number)
    instance_metadata_tags      = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "volume_tags" {
  description = "Tags to apply to volumes"
  type        = map(string)
  default     = {}
}
