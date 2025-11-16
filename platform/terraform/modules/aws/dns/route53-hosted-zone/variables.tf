variable "name" {
  description = "Name of the hosted zone (domain name)"
  type        = string
}

variable "comment" {
  description = "Comment for the hosted zone"
  type        = string
  default     = ""
}

variable "force_destroy" {
  description = "Force destroy all records in the zone when deleting"
  type        = bool
  default     = false
}

variable "vpc_config" {
  description = "VPC configuration for private hosted zone"
  type = list(object({
    vpc_id     = string
    vpc_region = optional(string)
  }))
  default = []
}

variable "delegation_set_id" {
  description = "ID of the reusable delegation set"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
