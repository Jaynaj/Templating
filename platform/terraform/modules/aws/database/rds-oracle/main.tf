resource "aws_db_instance" "this" {
  # Configure your RDS Oracle instance here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
