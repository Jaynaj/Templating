resource "aws_lb_listener" "this" {
  # Configure your ALB Listener here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
