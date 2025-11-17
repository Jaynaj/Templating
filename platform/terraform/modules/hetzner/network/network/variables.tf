variable "name" {
  description = "Name of the network"
  type        = string
}

variable "ip_range" {
  description = "IP range of the network"
  type        = string
}

variable "subnets" {
  description = "List of subnets"
  type = list(object({
    type         = string
    network_zone = string
    ip_range     = string
  }))
  default = []
}

variable "routes" {
  description = "List of routes"
  type = list(object({
    destination = string
    gateway     = string
  }))
  default = []
}

variable "labels" {
  description = "Labels"
  type        = map(string)
  default     = {}
}

variable "delete_protection" {
  description = "Enable delete protection"
  type        = bool
  default     = false
}
