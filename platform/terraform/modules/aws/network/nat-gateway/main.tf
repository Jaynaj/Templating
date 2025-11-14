resource "aws_eip" "this" {
  count = var.create_eip ? var.nat_gateway_count : 0

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-eip-${count.index + 1}"
    }
  )

  depends_on = [var.internet_gateway_id]
}

resource "aws_nat_gateway" "this" {
  count = var.nat_gateway_count

  allocation_id     = var.create_eip ? aws_eip.this[count.index].id : var.eip_ids[count.index]
  subnet_id         = var.subnet_ids[count.index]
  connectivity_type = var.connectivity_type

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${count.index + 1}"
    }
  )

  depends_on = [var.internet_gateway_id]
}
