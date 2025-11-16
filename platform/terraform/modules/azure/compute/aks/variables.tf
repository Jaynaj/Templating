variable "name" {
  description = "Name of the AKS cluster"
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

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = null
}

variable "default_node_pool" {
  description = "Default node pool configuration"
  type = object({
    name                = string
    node_count          = optional(number)
    min_count           = optional(number)
    max_count           = optional(number)
    vm_size             = string
    os_disk_size_gb     = optional(number)
    vnet_subnet_id      = optional(string)
    enable_auto_scaling = optional(bool)
    zones               = optional(list(string))
    max_pods            = optional(number)
    node_labels         = optional(map(string))
    node_taints         = optional(list(string))
  })
}

variable "identity" {
  description = "Managed identity configuration"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
}

variable "network_profile" {
  description = "Network profile configuration"
  type = object({
    network_plugin     = string
    network_policy     = optional(string)
    dns_service_ip     = optional(string)
    docker_bridge_cidr = optional(string)
    service_cidr       = optional(string)
    load_balancer_sku  = optional(string)
  })
  default = null
}

variable "role_based_access_control_enabled" {
  description = "Enable RBAC"
  type        = bool
  default     = true
}

variable "azure_active_directory_role_based_access_control" {
  description = "Azure AD RBAC configuration"
  type = object({
    managed                = bool
    admin_group_object_ids = optional(list(string))
    azure_rbac_enabled     = optional(bool)
  })
  default = null
}

variable "oms_agent" {
  description = "OMS agent configuration"
  type = object({
    log_analytics_workspace_id = string
  })
  default = null
}

variable "private_cluster_enabled" {
  description = "Enable private cluster"
  type        = bool
  default     = false
}

variable "sku_tier" {
  description = "SKU tier (Free, Standard, Premium)"
  type        = string
  default     = "Free"
}

variable "automatic_channel_upgrade" {
  description = "Automatic channel upgrade (patch, rapid, node-image, stable)"
  type        = string
  default     = null
}

variable "node_resource_group" {
  description = "Resource group for nodes"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
