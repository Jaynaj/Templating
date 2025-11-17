output "id" {
  description = "ID of the snapshot"
  value       = hcloud_server_snapshot.this.id
}

output "description" {
  description = "Description of the snapshot"
  value       = hcloud_server_snapshot.this.description
}
