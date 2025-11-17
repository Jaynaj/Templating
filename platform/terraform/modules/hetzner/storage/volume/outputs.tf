output "id" {
  description = "ID of the volume"
  value       = hcloud_volume.this.id
}

output "name" {
  description = "Name of the volume"
  value       = hcloud_volume.this.name
}

output "size" {
  description = "Size of the volume in GB"
  value       = hcloud_volume.this.size
}

output "location" {
  description = "Location of the volume"
  value       = hcloud_volume.this.location
}

output "linux_device" {
  description = "Linux device path"
  value       = hcloud_volume.this.linux_device
}
