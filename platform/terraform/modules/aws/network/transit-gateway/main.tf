resource "aws_ec2_transit_gateway" "this" {
  # Configure your Transit Gateway here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
