
resource "aws_cloudwatch_metric_alarm" "alarm" {
  for_each             = var.alarms
  alarm_name           = each.key
  metric_name          = each.value.metric_name
  namespace            = each.value.namespace
  threshold            = each.value.threshold
  comparison_operator  = each.value.comparison_operator
  evaluation_periods   = 2
  period               = 120
  statistic            = "Average"
  alarm_actions        = each.value.alarm_actions
}