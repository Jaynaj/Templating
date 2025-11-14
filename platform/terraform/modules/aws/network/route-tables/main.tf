resource "aws_route_table" "this" {
  # Configure your Route tables here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
