variable "name" {
  description = "Name prefix for NAT Gateways"
  type        = string
}

variable "nat_gateway_count" {
  description = "Number of NAT Gateways to create (typically 1 per AZ)"
  type        = number
  default     = 1
}

variable "subnet_ids" {
  description = "List of public subnet IDs for NAT Gateways"
  type        = list(string)
}

variable "create_eip" {
  description = "Create Elastic IPs for NAT Gateways"
  type        = bool
  default     = true
}

variable "eip_ids" {
  description = "List of Elastic IP allocation IDs (if not creating new)"
  type        = list(string)
  default     = []
}

variable "connectivity_type" {
  description = "Connectivity type (public or private)"
  type        = string
  default     = "public"
}

variable "internet_gateway_id" {
  description = "Internet Gateway ID (for dependency)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
