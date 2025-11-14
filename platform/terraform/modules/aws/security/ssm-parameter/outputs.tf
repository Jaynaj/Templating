output "id" {
  description = "ID of the parameter"
  value       = aws_ssm_parameter.this.id
}

output "arn" {
  description = "ARN of the parameter"
  value       = try(aws_ssm_parameter.this.arn, null)
}
