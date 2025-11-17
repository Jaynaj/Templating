variable "name" {
  description = "Name of the Load Balancer"
  type        = string
}

variable "load_balancer_type" {
  description = "Type of Load Balancer (lb11, lb21, lb31)"
  type        = string
}

variable "location" {
  description = "Location (nbg1, fsn1, hel1, ash, hil)"
  type        = string
  default     = null
}

variable "network_zone" {
  description = "Network zone (eu-central, us-east, us-west)"
  type        = string
  default     = null
}

variable "algorithm" {
  description = "Algorithm (round_robin or least_connections)"
  type        = string
  default     = "round_robin"
}

variable "services" {
  description = "List of services"
  type = list(object({
    protocol         = string
    listen_port      = number
    destination_port = number
    proxyprotocol    = optional(bool)
    http = optional(object({
      sticky_sessions = optional(bool)
      cookie_name     = optional(string)
      cookie_lifetime = optional(number)
      certificates    = optional(list(number))
      redirect_http   = optional(bool)
    }))
    health_check = object({
      protocol = string
      port     = number
      interval = number
      timeout  = number
      retries  = number
      http = optional(object({
        domain       = optional(string)
        path         = optional(string)
        response     = optional(string)
        status_codes = optional(list(string))
        tls          = optional(bool)
      }))
    })
  }))
  default = []
}

variable "targets" {
  description = "List of targets"
  type = list(object({
    type              = string
    server_id         = optional(number)
    label_selector    = optional(string)
    ip                = optional(string)
    use_private_ip    = optional(bool)
  }))
  default = []
}

variable "network_id" {
  description = "Network ID for private network"
  type        = number
  default     = null
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
