resource "aws_eip" "this" {
  # Configure your Elastic IP here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
