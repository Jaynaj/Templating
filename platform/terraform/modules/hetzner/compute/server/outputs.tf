output "id" {
  description = "ID of the server"
  value       = hcloud_server.this.id
}

output "name" {
  description = "Name of the server"
  value       = hcloud_server.this.name
}

output "status" {
  description = "Status of the server"
  value       = hcloud_server.this.status
}

output "ipv4_address" {
  description = "IPv4 address"
  value       = hcloud_server.this.ipv4_address
}

output "ipv6_address" {
  description = "IPv6 address"
  value       = hcloud_server.this.ipv6_address
}

output "ipv6_network" {
  description = "IPv6 network"
  value       = hcloud_server.this.ipv6_network
}

output "backup_window" {
  description = "Backup window"
  value       = hcloud_server.this.backup_window
}
