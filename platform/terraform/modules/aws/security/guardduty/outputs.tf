output "id" {
  description = "ID of the detector"
  value       = aws_guardduty_detector.this.id
}

output "arn" {
  description = "ARN of the detector"
  value       = try(aws_guardduty_detector.this.arn, null)
}
