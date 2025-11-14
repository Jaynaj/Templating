variable "name" {
  description = "Name of the launch template"
  type        = string
}

variable "description" {
  description = "Description of the launch template"
  type        = string
  default     = ""
}

variable "image_id" {
  description = "AMI ID"
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = null
}

variable "key_name" {
  description = "Key pair name"
  type        = string
  default     = null
}

variable "user_data" {
  description = "Base64-encoded user data"
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "Enable EBS optimization"
  type        = bool
  default     = null
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  type        = string
  default     = null
}

variable "block_device_mappings" {
  description = "Block device mappings"
  type        = list(any)
  default     = []
}

variable "capacity_reservation_specification" {
  description = "Capacity reservation specification"
  type        = any
  default     = null
}

variable "cpu_options" {
  description = "CPU options"
  type = object({
    core_count       = optional(number)
    threads_per_core = optional(number)
  })
  default = null
}

variable "credit_specification" {
  description = "Credit specification for burstable instances"
  type = object({
    cpu_credits = string
  })
  default = null
}

variable "disable_api_stop" {
  description = "Disable API stop"
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "Disable API termination"
  type        = bool
  default     = false
}

variable "elastic_gpu_specifications" {
  description = "Elastic GPU specifications"
  type = list(object({
    type = string
  }))
  default = []
}

variable "elastic_inference_accelerator" {
  description = "Elastic Inference accelerator"
  type = object({
    type = string
  })
  default = null
}

variable "enclave_options_enabled" {
  description = "Enable enclave options"
  type        = bool
  default     = null
}

variable "hibernation_configured" {
  description = "Enable hibernation"
  type        = bool
  default     = null
}

variable "instance_market_options" {
  description = "Instance market options (for Spot instances)"
  type        = any
  default     = null
}

variable "license_specifications" {
  description = "License specifications"
  type = list(object({
    license_configuration_arn = string
  }))
  default = []
}

variable "metadata_options" {
  description = "Instance metadata options"
  type = object({
    http_endpoint               = optional(string)
    http_tokens                 = optional(string)
    http_put_response_hop_limit = optional(number)
    http_protocol_ipv6          = optional(string)
    instance_metadata_tags      = optional(string)
  })
  default = null
}

variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = null
}

variable "network_interfaces" {
  description = "Network interface specifications"
  type        = list(any)
  default     = []
}

variable "placement" {
  description = "Placement configuration"
  type = object({
    affinity                = optional(string)
    availability_zone       = optional(string)
    group_name              = optional(string)
    host_id                 = optional(string)
    host_resource_group_arn = optional(string)
    partition_number        = optional(number)
    spread_domain           = optional(string)
    tenancy                 = optional(string)
  })
  default = null
}

variable "tag_specifications" {
  description = "Tag specifications for resources created by instances"
  type = list(object({
    resource_type = string
    tags          = map(string)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to the launch template"
  type        = map(string)
  default     = {}
}
