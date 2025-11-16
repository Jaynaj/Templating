variable "name" {
  description = "Name of the PrivateLink endpoint"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "service_name" {
  description = "Service name for the VPC endpoint"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for the endpoint"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
  default     = []
}

variable "private_dns_enabled" {
  description = "Enable private DNS"
  type        = bool
  default     = true
}

variable "acceptance_required" {
  description = "Acceptance required for endpoint connection"
  type        = bool
  default     = false
}

variable "allowed_principals" {
  description = "ARNs of principals allowed to discover the endpoint"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
