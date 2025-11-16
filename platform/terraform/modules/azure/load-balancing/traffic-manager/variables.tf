variable "name" {
  description = "Name of the Traffic Manager Profile"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "traffic_routing_method" {
  description = "Traffic routing method (Performance, Weighted, Priority, Geographic, MultiValue, Subnet)"
  type        = string
}

variable "dns_config" {
  description = "DNS configuration"
  type = object({
    relative_name = string
    ttl           = number
  })
}

variable "monitor_config" {
  description = "Monitor configuration"
  type = object({
    protocol                     = string
    port                         = number
    path                         = optional(string)
    interval_in_seconds          = optional(number)
    timeout_in_seconds           = optional(number)
    tolerated_number_of_failures = optional(number)
    expected_status_code_ranges  = optional(list(string))
    custom_header = optional(list(object({
      name  = string
      value = string
    })))
  })
}

variable "traffic_view_enabled" {
  description = "Enable traffic view"
  type        = bool
  default     = false
}

variable "max_return" {
  description = "Maximum number of endpoints to return (MultiValue routing only)"
  type        = number
  default     = null
}

variable "endpoints" {
  description = "Traffic Manager endpoints"
  type = list(object({
    name               = string
    type               = string
    target             = optional(string)
    target_resource_id = optional(string)
    weight             = optional(number)
    priority           = optional(number)
    endpoint_location  = optional(string)
    min_child_endpoints = optional(number)
    geo_mappings       = optional(list(string))
    custom_header = optional(list(object({
      name  = string
      value = string
    })))
    subnet = optional(list(object({
      first = string
      last  = optional(string)
      scope = optional(number)
    })))
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
