output "id" {
  description = "ID of the image"
  value       = data.hcloud_image.this.id
}

output "name" {
  description = "Name of the image"
  value       = data.hcloud_image.this.name
}

output "type" {
  description = "Type of the image"
  value       = data.hcloud_image.this.type
}

output "os_flavor" {
  description = "OS flavor"
  value       = data.hcloud_image.this.os_flavor
}

output "os_version" {
  description = "OS version"
  value       = data.hcloud_image.this.os_version
}
