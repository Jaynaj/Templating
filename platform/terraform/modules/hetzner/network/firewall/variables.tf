variable "name" {
  description = "Name of the firewall"
  type        = string
}

variable "rules" {
  description = "List of firewall rules"
  type = list(object({
    direction       = string
    protocol        = string
    port            = optional(string)
    source_ips      = optional(list(string))
    destination_ips = optional(list(string))
    description     = optional(string)
  }))
  default = []
}

variable "apply_to" {
  description = "Resources to apply firewall to"
  type = list(object({
    server         = optional(number)
    label_selector = optional(string)
  }))
  default = []
}

variable "labels" {
  description = "Labels"
  type        = map(string)
  default     = {}
}
