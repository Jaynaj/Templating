resource "aws_config_configuration_recorder" "this" {
  # Configure your AWS Config baseline here

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
