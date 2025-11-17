output "id" {
  description = "ID of the Floating IP"
  value       = hcloud_floating_ip.this.id
}

output "name" {
  description = "Name of the Floating IP"
  value       = hcloud_floating_ip.this.name
}

output "ip_address" {
  description = "IP address"
  value       = hcloud_floating_ip.this.ip_address
}

output "ip_network" {
  description = "IP network (for IPv6)"
  value       = hcloud_floating_ip.this.ip_network
}

output "home_location" {
  description = "Home location"
  value       = hcloud_floating_ip.this.home_location
}
