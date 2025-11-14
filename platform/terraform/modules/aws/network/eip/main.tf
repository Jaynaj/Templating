resource "aws_eip" "this" {
  count = var.eip_count

  domain            = "vpc"
  network_interface = var.network_interface_ids != [] ? var.network_interface_ids[count.index] : null
  instance          = var.instance_ids != [] ? var.instance_ids[count.index] : null
  associate_with_private_ip = var.associate_with_private_ip

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-${count.index + 1}"
    }
  )
}