output "eip_ids" {
  description = "EIP allocation IDs"
  value       = aws_eip.this[*].id
}

output "public_ips" {
  description = "Public IP addresses"
  value       = aws_eip.this[*].public_ip
}

output "private_ips" {
  description = "Private IP addresses"
  value       = aws_eip.this[*].private_ip
}