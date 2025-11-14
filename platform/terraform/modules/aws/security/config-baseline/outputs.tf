output "id" {
  description = "ID of the recorder"
  value       = aws_config_configuration_recorder.this.id
}

output "arn" {
  description = "ARN of the recorder"
  value       = try(aws_config_configuration_recorder.this.arn, null)
}
