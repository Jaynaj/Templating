resource "aws_xray_group" "this" {
  # Configure your X-Ray tracing here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
