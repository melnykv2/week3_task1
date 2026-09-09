resource "aws_cloudwatch_event_rule" "autoscaling_events" {
  name = "autoscaling-events"
  description = "Capture EC2 Auto Scaling events."

  event_pattern = jsonencode({
    source = [
      "aws.autoscaling"
    ]

    detail-type = [
      "EC2 Instance Launch Successful",
      "EC2 Instance Terminate Successful"
    ]

    detail = {
      AutoScalingGroupName = [
        module.nodejs-asg.autoscaling_group_name
      ]
    }
  })
}

resource "aws_cloudwatch_event_target" "autoscaling_sns_target" {
  rule = aws_cloudwatch_event_rule.autoscaling_events.name
  arn = aws_sns_topic.autoscaling_notifications.arn
}
