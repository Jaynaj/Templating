resource "aws_db_instance" "this" {
  # Configure your RDS MySQL instance here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
