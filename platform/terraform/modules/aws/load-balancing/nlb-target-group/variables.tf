variable "name" {
  description = "Name of the target group"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "port" {
  description = "Port for the target group"
  type        = number
}

variable "protocol" {
  description = "Protocol (TCP, TLS, UDP, TCP_UDP)"
  type        = string
}

variable "target_type" {
  description = "Type of target (instance, ip, alb)"
  type        = string
  default     = "instance"
}

variable "deregistration_delay" {
  description = "Deregistration delay in seconds"
  type        = number
  default     = 300
}

variable "connection_termination" {
  description = "Enable connection termination on deregistration"
  type        = bool
  default     = false
}

variable "preserve_client_ip" {
  description = "Preserve client IP address"
  type        = string
  default     = null
}

variable "proxy_protocol_v2" {
  description = "Enable proxy protocol v2"
  type        = bool
  default     = false
}

variable "health_check" {
  description = "Health check configuration"
  type = object({
    enabled             = optional(bool)
    interval            = optional(number)
    path                = optional(string)
    port                = optional(string)
    protocol            = optional(string)
    timeout             = optional(number)
    healthy_threshold   = optional(number)
    unhealthy_threshold = optional(number)
    matcher             = optional(string)
  })
  default = {}
}

variable "stickiness" {
  description = "Stickiness configuration"
  type = object({
    enabled = bool
    type    = string
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
