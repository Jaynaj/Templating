output "id" {
  description = "ID of the gateway"
  value       = aws_ec2_transit_gateway.this.id
}

output "arn" {
  description = "ARN of the gateway"
  value       = try(aws_ec2_transit_gateway.this.arn, null)
}
