resource "aws_lb" "this" {
  # Configure your Network Load Balancer here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
