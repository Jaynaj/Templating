output "table_id" {
  description = "Table ID"
  value       = aws_dynamodb_table.this.id
}

output "table_arn" {
  description = "Table ARN"
  value       = aws_dynamodb_table.this.arn
}

output "table_name" {
  description = "Table name"
  value       = aws_dynamodb_table.this.name
}

output "stream_arn" {
  description = "Stream ARN"
  value       = aws_dynamodb_table.this.stream_arn
}

output "stream_label" {
  description = "Stream label"
  value       = aws_dynamodb_table.this.stream_label
}
