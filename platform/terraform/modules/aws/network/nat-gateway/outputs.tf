output "nat_gateway_ids" {
  description = "List of NAT Gateway IDs"
  value       = aws_nat_gateway.this[*].id
}

output "eip_ids" {
  description = "List of Elastic IP IDs"
  value       = var.create_eip ? aws_eip.this[*].id : []
}

output "eip_public_ips" {
  description = "List of Elastic IP public addresses"
  value       = var.create_eip ? aws_eip.this[*].public_ip : []
}

output "nat_gateway_network_interface_ids" {
  description = "List of NAT Gateway ENI IDs"
  value       = aws_nat_gateway.this[*].network_interface_id
}
