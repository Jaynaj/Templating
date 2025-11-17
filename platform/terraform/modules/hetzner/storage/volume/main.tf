resource "hcloud_volume" "this" {
  name              = var.name
  size              = var.size
  location          = var.location
  server_id         = var.server_id
  automount         = var.automount
  format            = var.format
  labels            = var.labels
  delete_protection = var.delete_protection
}
