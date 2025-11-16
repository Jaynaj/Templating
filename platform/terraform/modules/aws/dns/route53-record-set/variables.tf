variable "zone_id" {
  description = "ID of the Route53 hosted zone"
  type        = string
}

variable "name" {
  description = "Name of the DNS record"
  type        = string
}

variable "type" {
  description = "Type of DNS record (A, AAAA, CNAME, etc.)"
  type        = string
}

variable "ttl" {
  description = "TTL for the record"
  type        = number
  default     = null
}

variable "records" {
  description = "List of DNS record values"
  type        = list(string)
  default     = []
}

variable "set_identifier" {
  description = "Unique identifier for routing policy records"
  type        = string
  default     = null
}

variable "health_check_id" {
  description = "Health check ID for the record"
  type        = string
  default     = null
}

variable "alias" {
  description = "Alias record configuration"
  type = object({
    name                   = string
    zone_id                = string
    evaluate_target_health = bool
  })
  default = null
}

variable "weighted_routing_policy" {
  description = "Weighted routing policy"
  type = object({
    weight = number
  })
  default = null
}

variable "latency_routing_policy" {
  description = "Latency routing policy"
  type = object({
    region = string
  })
  default = null
}

variable "geolocation_routing_policy" {
  description = "Geolocation routing policy"
  type = object({
    continent   = optional(string)
    country     = optional(string)
    subdivision = optional(string)
  })
  default = null
}

variable "failover_routing_policy" {
  description = "Failover routing policy"
  type = object({
    type = string
  })
  default = null
}

variable "multivalue_answer_routing_policy" {
  description = "Enable multivalue answer routing"
  type        = bool
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
