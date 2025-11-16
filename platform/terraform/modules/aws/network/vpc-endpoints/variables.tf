variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "endpoints" {
  description = "Map of VPC endpoint configurations"
  type = map(object({
    service_name      = string
    vpc_endpoint_type = optional(string)
    subnet_ids        = optional(list(string))
    security_group_ids = optional(list(string))
    route_table_ids   = optional(list(string))
    policy            = optional(string)
    private_dns_enabled = optional(bool)
  }))
  default = {}
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
