resource "aws_subnet" "this" {
  # Configure your Subnet sets for public/private per AZ here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
