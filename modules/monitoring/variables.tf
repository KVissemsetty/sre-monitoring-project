variable "name" {
  type = string
}



variable "alarms" {
  type = map(object({
    metric_name         = string
    namespace           = string
    threshold           = number
    comparison_operator = string
    alarm_actions       = list(string)
  }))
}