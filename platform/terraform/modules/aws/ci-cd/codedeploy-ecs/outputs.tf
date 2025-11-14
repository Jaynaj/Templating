output "id" {
  description = "ID of the group"
  value       = aws_codedeploy_deployment_group.this.id
}

output "arn" {
  description = "ARN of the group"
  value       = try(aws_codedeploy_deployment_group.this.arn, null)
}
