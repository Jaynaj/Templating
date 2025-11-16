resource "azurerm_kubernetes_cluster" "this" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  dns_prefix                        = var.dns_prefix
  kubernetes_version                = var.kubernetes_version
  role_based_access_control_enabled = var.role_based_access_control_enabled
  private_cluster_enabled           = var.private_cluster_enabled
  sku_tier                          = var.sku_tier
  automatic_channel_upgrade         = var.automatic_channel_upgrade
  node_resource_group               = var.node_resource_group

  default_node_pool {
    name                = var.default_node_pool.name
    node_count          = lookup(var.default_node_pool, "node_count", null)
    min_count           = lookup(var.default_node_pool, "min_count", null)
    max_count           = lookup(var.default_node_pool, "max_count", null)
    vm_size             = var.default_node_pool.vm_size
    os_disk_size_gb     = lookup(var.default_node_pool, "os_disk_size_gb", null)
    vnet_subnet_id      = lookup(var.default_node_pool, "vnet_subnet_id", null)
    enable_auto_scaling = lookup(var.default_node_pool, "enable_auto_scaling", false)
    zones               = lookup(var.default_node_pool, "zones", null)
    max_pods            = lookup(var.default_node_pool, "max_pods", null)
    node_labels         = lookup(var.default_node_pool, "node_labels", null)
    node_taints         = lookup(var.default_node_pool, "node_taints", null)
  }

  identity {
    type         = var.identity.type
    identity_ids = lookup(var.identity, "identity_ids", null)
  }

  dynamic "network_profile" {
    for_each = var.network_profile != null ? [var.network_profile] : []
    content {
      network_plugin     = network_profile.value.network_plugin
      network_policy     = lookup(network_profile.value, "network_policy", null)
      dns_service_ip     = lookup(network_profile.value, "dns_service_ip", null)
      docker_bridge_cidr = lookup(network_profile.value, "docker_bridge_cidr", null)
      service_cidr       = lookup(network_profile.value, "service_cidr", null)
      load_balancer_sku  = lookup(network_profile.value, "load_balancer_sku", "standard")
    }
  }

  dynamic "azure_active_directory_role_based_access_control" {
    for_each = var.azure_active_directory_role_based_access_control != null ? [var.azure_active_directory_role_based_access_control] : []
    content {
      managed                = azure_active_directory_role_based_access_control.value.managed
      admin_group_object_ids = lookup(azure_active_directory_role_based_access_control.value, "admin_group_object_ids", null)
      azure_rbac_enabled     = lookup(azure_active_directory_role_based_access_control.value, "azure_rbac_enabled", null)
    }
  }

  dynamic "oms_agent" {
    for_each = var.oms_agent != null ? [var.oms_agent] : []
    content {
      log_analytics_workspace_id = oms_agent.value.log_analytics_workspace_id
    }
  }

  tags = var.tags
}
