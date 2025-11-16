resource "aws_ssm_parameter" "this" {
  name            = var.name
  description     = var.description
  type            = var.type
  value           = var.value
  tier            = var.tier
  key_id          = var.type == "SecureString" ? var.key_id : null
  allowed_pattern = var.allowed_pattern
  data_type       = var.data_type

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
