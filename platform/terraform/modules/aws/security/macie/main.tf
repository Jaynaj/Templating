resource "aws_macie2_account" "this" {
  # Configure your Macie account here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
