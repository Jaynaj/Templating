resource "aws_vpc_endpoint" "this" {
  for_each = var.endpoints

  vpc_id            = var.vpc_id
  service_name      = each.value.service_name
  vpc_endpoint_type = lookup(each.value, "vpc_endpoint_type", "Interface")

  subnet_ids         = lookup(each.value, "subnet_ids", null)
  security_group_ids = lookup(each.value, "security_group_ids", null)
  route_table_ids    = lookup(each.value, "route_table_ids", null)
  policy             = lookup(each.value, "policy", null)
  private_dns_enabled = lookup(each.value, "private_dns_enabled", true)

  tags = merge(
    var.tags,
    {
      Name = each.key
    }
  )
}
