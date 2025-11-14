output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.this.id
}

output "instance_arn" {
  description = "ARN of the EC2 instance"
  value       = aws_instance.this.arn
}

output "instance_state" {
  description = "State of the instance"
  value       = aws_instance.this.instance_state
}

output "instance_public_ip" {
  description = "Public IP address"
  value       = aws_instance.this.public_ip
}

output "instance_private_ip" {
  description = "Private IP address"
  value       = aws_instance.this.private_ip
}

output "instance_public_dns" {
  description = "Public DNS name"
  value       = aws_instance.this.public_dns
}

output "instance_private_dns" {
  description = "Private DNS name"
  value       = aws_instance.this.private_dns
}

output "instance_availability_zone" {
  description = "Availability zone of the instance"
  value       = aws_instance.this.availability_zone
}

output "root_block_device_id" {
  description = "ID of the root block device"
  value       = try(aws_instance.this.root_block_device[0].volume_id, null)
}

output "ebs_block_device_ids" {
  description = "IDs of attached EBS volumes"
  value       = try(aws_instance.this.ebs_block_device[*].volume_id, [])
}
