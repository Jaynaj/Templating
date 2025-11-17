resource "hcloud_server" "this" {
  name               = var.name
  server_type        = var.server_type
  image              = var.image
  location           = var.location
  datacenter         = var.datacenter
  ssh_keys           = var.ssh_keys
  user_data          = var.user_data
  backups            = var.backups
  iso                = var.iso
  rescue             = var.rescue
  labels             = var.labels
  keep_disk          = var.keep_disk
  firewall_ids       = var.firewall_ids
  placement_group_id = var.placement_group_id
  delete_protection  = var.delete_protection
  rebuild_protection = var.rebuild_protection

  dynamic "public_net" {
    for_each = var.public_net != null ? [var.public_net] : []
    content {
      ipv4_enabled = lookup(public_net.value, "ipv4_enabled", true)
      ipv6_enabled = lookup(public_net.value, "ipv6_enabled", true)
      ipv4         = lookup(public_net.value, "ipv4", null)
      ipv6         = lookup(public_net.value, "ipv6", null)
    }
  }

  dynamic "network" {
    for_each = var.network
    content {
      network_id = network.value.network_id
      ip         = lookup(network.value, "ip", null)
      alias_ips  = lookup(network.value, "alias_ips", null)
    }
  }
}
