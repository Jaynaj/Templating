resource "aws_internet_gateway" "this" {
  # Configure your Internet Gateway here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
