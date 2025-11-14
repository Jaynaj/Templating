resource "aws_vpc_endpoint" "this" {
  # Configure your VPC Endpoints here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
