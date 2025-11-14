output "autoscaling_group_id" {
  description = "ID of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.id
}

output "autoscaling_group_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}

output "autoscaling_group_arn" {
  description = "ARN of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.arn
}

output "autoscaling_group_min_size" {
  description = "Minimum size of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.min_size
}

output "autoscaling_group_max_size" {
  description = "Maximum size of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.max_size
}

output "autoscaling_group_desired_capacity" {
  description = "Desired capacity of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.desired_capacity
}

output "autoscaling_group_default_cooldown" {
  description = "Default cooldown period"
  value       = aws_autoscaling_group.this.default_cooldown
}

output "autoscaling_group_health_check_type" {
  description = "Health check type"
  value       = aws_autoscaling_group.this.health_check_type
}

output "autoscaling_group_availability_zones" {
  description = "Availability zones of the Auto Scaling Group"
  value       = aws_autoscaling_group.this.availability_zones
}

output "scaling_policy_arns" {
  description = "ARNs of scaling policies"
  value       = { for k, v in aws_autoscaling_policy.this : k => v.arn }
}
