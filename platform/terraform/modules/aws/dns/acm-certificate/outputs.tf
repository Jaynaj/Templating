output "id" {
  description = "ID of the certificate"
  value       = aws_acm_certificate.this.id
}

output "arn" {
  description = "ARN of the certificate"
  value       = try(aws_acm_certificate.this.arn, null)
}
