resource "aws_cloudwatch_composite_alarm" "this" {
  alarm_name          = var.name
  alarm_description   = var.alarm_description
  alarm_rule          = var.alarm_rule
  actions_enabled     = var.actions_enabled
  alarm_actions       = var.alarm_actions
  ok_actions          = var.ok_actions
  insufficient_data_actions = var.insufficient_data_actions

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )
}
