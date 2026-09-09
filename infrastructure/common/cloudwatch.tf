resource "aws_cloudwatch_metric_alarm" "increase_ec2_alarm" {

  alarm_name = "increase-ec2-alarm"
  alarm_description = "This metric monitors ec2 cpu utilization, if it goes above 70% for 2 periods it will trigger an alarm."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 120
  statistic = "Average"
  threshold = 50
  insufficient_data_actions = []
  alarm_actions = [
    "${aws_sns_topic.nodejs_sns_topic.arn}",
    "${aws_autoscaling_policy.nodejs-scaling-policy.arn}"
  ]
}

resource "aws_cloudwatch_metric_alarm" "reduce_ec2_alarm" {
  alarm_name = "reduce-ec2-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods = 2
  metric_name = "CPUUtilization"
  namespace = "AWS/EC2"
  period = 120
  statistic = "Average"
  threshold = 30
  alarm_description = "This metric monitors ec2 cpu utilization, if it goes below 40% for 2 periods it will trigger an alarm."
  insufficient_data_actions = []
  alarm_actions = [
    "${aws_sns_topic.nodejs_sns_topic.arn}",
    "${aws_autoscaling_policy.nodejs-scaling-policy.arn}"
  ]
}
