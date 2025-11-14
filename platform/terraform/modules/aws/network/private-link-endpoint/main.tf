resource "aws_vpc_endpoint" "this" {
  # Configure your PrivateLink Endpoint here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
