resource "aws_rds_cluster" "this" {
  # Configure your Aurora MySQL cluster here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
