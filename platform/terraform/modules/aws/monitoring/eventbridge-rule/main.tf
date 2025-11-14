resource "aws_cloudwatch_event_rule" "this" {
  name                = var.name
  description         = var.description
  event_pattern       = var.event_pattern
  schedule_expression = var.schedule_expression
  state               = var.state
  role_arn            = var.role_arn
  event_bus_name      = var.event_bus_name

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}

resource "aws_cloudwatch_event_target" "this" {
  count = length(var.targets)

  rule      = aws_cloudwatch_event_rule.this.name
  target_id = "${var.name}-target-${count.index}"
  arn       = var.targets[count.index].arn
  role_arn  = lookup(var.targets[count.index], "role_arn", null)
  input     = lookup(var.targets[count.index], "input", null)
}
