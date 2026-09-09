resource "aws_sns_topic" "autoscaling_notifications" {
  name = "autoscaling-notifications"

  tags = {
    Name = "autoscaling-notifications"
  }
}

resource "aws_sns_topic_subscription" "autoscaling_email_subscription" {
  topic_arn = aws_sns_topic.autoscaling_notifications.arn
  protocol = "email"
  endpoint = var.notification_email
}
