output "id" {
  description = "ID of the validation"
  value       = aws_acm_certificate_validation.this.id
}

output "arn" {
  description = "ARN of the validation"
  value       = try(aws_acm_certificate_validation.this.arn, null)
}
