variable "name" {
  description = "Name of the Action Group"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "short_name" {
  description = "Short name (max 12 characters)"
  type        = string
}

variable "enabled" {
  description = "Enable the action group"
  type        = bool
  default     = true
}

variable "email_receivers" {
  description = "Email receivers"
  type = list(object({
    name                    = string
    email_address           = string
    use_common_alert_schema = optional(bool)
  }))
  default = []
}

variable "sms_receivers" {
  description = "SMS receivers"
  type = list(object({
    name         = string
    country_code = string
    phone_number = string
  }))
  default = []
}

variable "webhook_receivers" {
  description = "Webhook receivers"
  type = list(object({
    name                    = string
    service_uri             = string
    use_common_alert_schema = optional(bool)
  }))
  default = []
}

variable "azure_app_push_receivers" {
  description = "Azure App push receivers"
  type = list(object({
    name          = string
    email_address = string
  }))
  default = []
}

variable "azure_function_receivers" {
  description = "Azure Function receivers"
  type = list(object({
    name                     = string
    function_app_resource_id = string
    function_name            = string
    http_trigger_url         = string
    use_common_alert_schema  = optional(bool)
  }))
  default = []
}

variable "logic_app_receivers" {
  description = "Logic App receivers"
  type = list(object({
    name                    = string
    resource_id             = string
    callback_url            = string
    use_common_alert_schema = optional(bool)
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
