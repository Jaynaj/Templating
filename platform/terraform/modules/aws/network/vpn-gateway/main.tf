resource "aws_vpn_gateway" "this" {
  # Configure your VPN Gateway here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
