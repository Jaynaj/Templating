variable "name" {
  description = "Name of the Container Group"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "os_type" {
  description = "Operating system type (Linux or Windows)"
  type        = string
  default     = "Linux"
}

variable "restart_policy" {
  description = "Restart policy (Always, OnFailure, Never)"
  type        = string
  default     = "Always"
}

variable "ip_address_type" {
  description = "IP address type (Public, Private, None)"
  type        = string
  default     = "Public"
}

variable "dns_name_label" {
  description = "DNS name label"
  type        = string
  default     = null
}

variable "subnet_ids" {
  description = "List of subnet IDs for private IP"
  type        = list(string)
  default     = []
}

variable "containers" {
  description = "List of containers"
  type = list(object({
    name   = string
    image  = string
    cpu    = number
    memory = number
    ports = optional(list(object({
      port     = number
      protocol = string
    })))
    environment_variables = optional(map(string))
    secure_environment_variables = optional(map(string))
    commands = optional(list(string))
    volume = optional(list(object({
      name       = string
      mount_path = string
      read_only  = optional(bool)
      share_name = optional(string)
      storage_account_name = optional(string)
      storage_account_key  = optional(string)
    })))
  }))
}

variable "image_registry_credential" {
  description = "Image registry credentials"
  type = object({
    server   = string
    username = string
    password = string
  })
  default = null
}

variable "identity" {
  description = "Managed identity configuration"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
