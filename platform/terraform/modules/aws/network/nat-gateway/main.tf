resource "aws_nat_gateway" "this" {
  # Configure your NAT Gateway here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
