variable "name" {
  description = "Name of the VM Scale Set"
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

variable "sku" {
  description = "SKU of the VM instances"
  type        = string
}

variable "instances" {
  description = "Number of VM instances"
  type        = number
  default     = 2
}

variable "admin_username" {
  description = "Admin username"
  type        = string
}

variable "admin_password" {
  description = "Admin password"
  type        = string
  default     = null
  sensitive   = true
}

variable "disable_password_authentication" {
  description = "Disable password authentication (Linux only)"
  type        = bool
  default     = true
}

variable "ssh_public_keys" {
  description = "List of SSH public keys (Linux only)"
  type = list(object({
    public_key = string
  }))
  default = []
}

variable "os_disk" {
  description = "OS disk configuration"
  type = object({
    caching              = string
    storage_account_type = string
  })
}

variable "source_image_reference" {
  description = "Source image reference"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}

variable "network_interface" {
  description = "Network interface configuration"
  type = object({
    name    = string
    primary = bool
    ip_configuration = object({
      name                                   = string
      primary                                = bool
      subnet_id                              = string
      load_balancer_backend_address_pool_ids = optional(list(string))
      application_gateway_backend_address_pool_ids = optional(list(string))
    })
  })
}

variable "os_type" {
  description = "Operating system type (Linux or Windows)"
  type        = string
  validation {
    condition     = contains(["Linux", "Windows"], var.os_type)
    error_message = "OS type must be Linux or Windows"
  }
}

variable "upgrade_mode" {
  description = "Upgrade mode (Manual, Automatic, Rolling)"
  type        = string
  default     = "Manual"
}

variable "zones" {
  description = "Availability zones"
  type        = list(string)
  default     = []
}

variable "identity" {
  description = "Managed identity configuration"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "automatic_instance_repair" {
  description = "Automatic instance repair configuration"
  type = object({
    enabled      = bool
    grace_period = optional(string)
  })
  default = null
}

variable "health_probe_id" {
  description = "Health probe ID for automatic instance repair"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
