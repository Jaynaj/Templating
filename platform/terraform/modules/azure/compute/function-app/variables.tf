variable "name" {
  description = "Name of the Function App"
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

variable "storage_account_name" {
  description = "Storage account name for Function App"
  type        = string
}

variable "storage_account_access_key" {
  description = "Storage account access key"
  type        = string
  sensitive   = true
}

variable "app_settings" {
  description = "App settings"
  type        = map(string)
  default     = {}
}

variable "functions_extension_version" {
  description = "Functions extension version"
  type        = string
  default     = "~4"
}

variable "site_config" {
  description = "Site configuration"
  type = object({
    always_on                              = optional(bool)
    app_command_line                       = optional(string)
    ftps_state                             = optional(string)
    health_check_path                      = optional(string)
    http2_enabled                          = optional(bool)
    minimum_tls_version                    = optional(string)
    application_insights_key               = optional(string)
    application_insights_connection_string = optional(string)
    runtime_scale_monitoring_enabled       = optional(bool)
    use_32_bit_worker                      = optional(bool)
    websockets_enabled                     = optional(bool)
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

variable "client_certificate_enabled" {
  description = "Enable client certificates"
  type        = bool
  default     = false
}

variable "builtin_logging_enabled" {
  description = "Enable built-in logging"
  type        = bool
  default     = true
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
