variable "name" {
  description = "Name of the Front Door"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "sku_name" {
  description = "SKU name (Standard_AzureFrontDoor, Premium_AzureFrontDoor)"
  type        = string
  default     = "Standard_AzureFrontDoor"
}

variable "endpoints" {
  description = "Front Door endpoints"
  type = list(object({
    name    = string
    enabled = optional(bool)
  }))
}

variable "origin_groups" {
  description = "Origin groups"
  type = list(object({
    name = string
    health_probe = object({
      interval_in_seconds = number
      path                = string
      protocol            = string
      request_type        = string
    })
    load_balancing = object({
      additional_latency_in_milliseconds = optional(number)
      sample_size                        = optional(number)
      successful_samples_required        = optional(number)
    })
  }))
}

variable "origins" {
  description = "Origins"
  type = list(object({
    name                           = string
    origin_group_name              = string
    host_name                      = string
    certificate_name_check_enabled = optional(bool)
    enabled                        = optional(bool)
    http_port                      = optional(number)
    https_port                     = optional(number)
    origin_host_header             = optional(string)
    priority                       = optional(number)
    weight                         = optional(number)
    private_link = optional(object({
      request_message        = optional(string)
      target_type            = optional(string)
      location               = string
      private_link_target_id = string
    }))
  }))
}

variable "routes" {
  description = "Routes"
  type = list(object({
    name                          = string
    endpoint_name                 = string
    origin_group_name             = string
    forwarding_protocol           = optional(string)
    https_redirect_enabled        = optional(bool)
    patterns_to_match             = list(string)
    supported_protocols           = list(string)
    cache = optional(object({
      query_string_caching_behavior = optional(string)
      query_strings                 = optional(list(string))
      compression_enabled           = optional(bool)
      content_types_to_compress     = optional(list(string))
    }))
    link_to_default_domain = optional(bool)
    enabled                = optional(bool)
  }))
}

variable "rule_sets" {
  description = "Rule sets"
  type = list(object({
    name = string
  }))
  default = []
}

variable "security_policies" {
  description = "Security policies"
  type = list(object({
    name = string
    firewall = object({
      cdn_frontdoor_firewall_policy_id = string
      association = object({
        patterns_to_match = list(string)
        endpoint_names    = list(string)
      })
    })
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
