resource "aws_lb_target_group" "this" {
  # Configure your NLB Target Group here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
