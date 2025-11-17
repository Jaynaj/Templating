output "id" {
  description = "ID of the Load Balancer"
  value       = hcloud_load_balancer.this.id
}

output "name" {
  description = "Name of the Load Balancer"
  value       = hcloud_load_balancer.this.name
}

output "ipv4" {
  description = "IPv4 address"
  value       = hcloud_load_balancer.this.ipv4
}

output "ipv6" {
  description = "IPv6 address"
  value       = hcloud_load_balancer.this.ipv6
}

output "network_ip" {
  description = "Private network IP"
  value       = hcloud_load_balancer.this.network_ip
}
