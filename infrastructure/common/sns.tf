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

resource "aws_sns_topic_policy" "autoscaling_notifications_policy" {
  arn = aws_sns_topic.autoscaling_notifications.arn
  policy = jsonencode({
    Version = "2026-09-09"

    Statement = [
      {
        Sid = "AllowCloudWatchEventsToPublish"
        Effect = "Allow"

        Principal = {
          Service = "events.amazonaws.com"
        }

        Action = [
          "SNS:Publish"
        ]

        Resource = aws_sns_topic.autoscaling_notifications.arn

        Condition = {
          ArnEquals = {
            "aws:SourceArn" = aws_cloudwatch_event_rule.autoscaling_events.arn
          }
        }
      }
    ]
  })
}
