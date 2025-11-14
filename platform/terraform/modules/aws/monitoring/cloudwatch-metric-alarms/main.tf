resource "aws_cloudwatch_metric_alarm" "this" {
  for_each = var.alarms

  alarm_name          = each.key
  comparison_operator = each.value.comparison_operator
  evaluation_periods  = each.value.evaluation_periods
  metric_name         = each.value.metric_name
  namespace           = each.value.namespace
  period              = each.value.period
  statistic           = each.value.statistic
  threshold           = each.value.threshold

  alarm_description   = lookup(each.value, "alarm_description", null)
  alarm_actions       = lookup(each.value, "alarm_actions", [])
  ok_actions          = lookup(each.value, "ok_actions", [])
  insufficient_data_actions = lookup(each.value, "insufficient_data_actions", [])
  datapoints_to_alarm = lookup(each.value, "datapoints_to_alarm", null)
  treat_missing_data  = lookup(each.value, "treat_missing_data", "missing")
  dimensions          = lookup(each.value, "dimensions", {})

  tags = merge(
    var.tags,
    {
      Name = each.key
    }
  )
}
