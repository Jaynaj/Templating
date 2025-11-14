resource "aws_lb_target_group" "this" {
  # Configure your ALB Target Group here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
