variable "name" {
  description = "Name of the IAM role"
  type        = string
}

variable "description" {
  description = "Description of the IAM role"
  type        = string
  default     = ""
}

variable "assume_role_policy" {
  description = "Assume role policy document (JSON)"
  type        = string
}

variable "trusted_services" {
  description = "List of AWS services that can assume this role"
  type        = list(string)
  default     = []
}

variable "trusted_arns" {
  description = "List of ARNs that can assume this role"
  type        = list(string)
  default     = []
}

variable "max_session_duration" {
  description = "Maximum session duration in seconds"
  type        = number
  default     = 3600
}

variable "force_detach_policies" {
  description = "Force detach policies on destroy"
  type        = bool
  default     = false
}

variable "path" {
  description = "Path for the IAM role"
  type        = string
  default     = "/"
}

variable "permissions_boundary" {
  description = "ARN of the permissions boundary"
  type        = string
  default     = null
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policies"
  type = map(object({
    policy = string
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
