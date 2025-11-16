variable "name" {
  description = "Name of the App Service"
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

variable "service_plan_id" {
  description = "ID of the App Service Plan"
  type        = string
}

variable "app_settings" {
  description = "App settings"
  type        = map(string)
  default     = {}
}

variable "connection_string" {
  description = "Connection strings"
  type = list(object({
    name  = string
    type  = string
    value = string
  }))
  default = []
}

variable "site_config" {
  description = "Site configuration"
  type = object({
    always_on                               = optional(bool)
    app_command_line                        = optional(string)
    default_documents                       = optional(list(string))
    dotnet_framework_version                = optional(string)
    ftps_state                              = optional(string)
    health_check_path                       = optional(string)
    http2_enabled                           = optional(bool)
    linux_fx_version                        = optional(string)
    windows_fx_version                      = optional(string)
    minimum_tls_version                     = optional(string)
    scm_type                                = optional(string)
    use_32_bit_worker_process               = optional(bool)
    websockets_enabled                      = optional(bool)
    cors = optional(object({
      allowed_origins     = list(string)
      support_credentials = optional(bool)
    }))
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

variable "https_only" {
  description = "Enable HTTPS only"
  type        = bool
  default     = true
}

variable "client_affinity_enabled" {
  description = "Enable client affinity"
  type        = bool
  default     = false
}

variable "virtual_network_subnet_id" {
  description = "Virtual network subnet ID for VNet integration"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
