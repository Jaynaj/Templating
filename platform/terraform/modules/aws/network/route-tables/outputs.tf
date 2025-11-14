output "route_table_id" {
  description = "Route table ID"
  value       = aws_route_table.this.id
}

output "route_table_arn" {
  description = "Route table ARN"
  value       = aws_route_table.this.arn
}

output "association_ids" {
  description = "Route table association IDs"
  value       = [for assoc in aws_route_table_association.this : assoc.id]
}