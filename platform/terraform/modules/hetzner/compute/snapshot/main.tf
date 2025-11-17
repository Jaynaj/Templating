resource "hcloud_server_snapshot" "this" {
  server_id   = var.server_id
  description = var.description
  labels      = var.labels
}
