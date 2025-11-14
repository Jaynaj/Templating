variable "name" {
  description = "Name of the NLB"
  type        = string
}

variable "internal" {
  description = "Whether the NLB is internal"
  type        = bool
  default     = false
}

variable "subnets" {
  description = "Subnet IDs"
  type        = list(string)
  default     = []
}

variable "subnet_mappings" {
  description = "Subnet mappings with allocation IDs"
  type = list(object({
    subnet_id     = string
    allocation_id = optional(string)
    private_ipv4_address = optional(string)
    ipv6_address = optional(string)
  }))
  default = []
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  description = "Enable cross-zone load balancing"
  type        = bool
  default     = true
}

variable "ip_address_type" {
  description = "IP address type (ipv4 or dualstack)"
  type        = string
  default     = "ipv4"
}

variable "customer_owned_ipv4_pool" {
  description = "Customer owned IPv4 pool"
  type        = string
  default     = null
}

variable "enable_tls_version_and_cipher_suite_headers" {
  description = "Enable TLS version and cipher suite headers"
  type        = bool
  default     = false
}

variable "enable_xff_client_port" {
  description = "Enable X-Forwarded-For client port"
  type        = bool
  default     = false
}

variable "access_logs" {
  description = "Access logs configuration"
  type = object({
    bucket  = string
    prefix  = optional(string)
    enabled = optional(bool)
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
