resource "hcloud_floating_ip" "this" {
  type              = var.type
  name              = var.name
  description       = var.description
  home_location     = var.home_location
  server_id         = var.server_id
  labels            = var.labels
  delete_protection = var.delete_protection
}
