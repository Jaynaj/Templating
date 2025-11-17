output "id" {
  description = "ID of the network"
  value       = hcloud_network.this.id
}

output "name" {
  description = "Name of the network"
  value       = hcloud_network.this.name
}

output "ip_range" {
  description = "IP range of the network"
  value       = hcloud_network.this.ip_range
}

output "subnet_ids" {
  description = "IDs of the subnets"
  value       = { for k, v in hcloud_network_subnet.this : k => v.id }
}
