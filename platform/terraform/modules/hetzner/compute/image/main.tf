# This is a data source wrapper module for fetching existing images
# Use the snapshot module to create new snapshots

data "hcloud_image" "this" {
  with_selector = join(",", [for k, v in var.labels : "${k}=${v}"])
  most_recent   = true
}
