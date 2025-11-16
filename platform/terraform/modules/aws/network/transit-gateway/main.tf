resource "aws_ec2_transit_gateway" "this" {
  description                     = var.description
  amazon_side_asn                 = var.amazon_side_asn
  default_route_table_association = var.default_route_table_association
  default_route_table_propagation = var.default_route_table_propagation
  dns_support                     = var.dns_support
  vpn_ecmp_support                = var.vpn_ecmp_support
  auto_accept_shared_attachments  = var.auto_accept_shared_attachments
  multicast_support               = var.multicast_support
  transit_gateway_cidr_blocks     = var.transit_gateway_cidr_blocks

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
