resource "aws_vpn_gateway" "this" {
  vpc_id            = var.vpc_id
  amazon_side_asn   = var.amazon_side_asn
  availability_zone = var.availability_zone

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
