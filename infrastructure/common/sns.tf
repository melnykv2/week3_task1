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

data "aws_iam_policy_document" "autoscaling_notifications_policy" {
  statement {
    sid = "AllowEventBridgeToPublish"
    effect = "Allow"

    principals {
      type = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    actions = [
      "SNS:Publish"
    ]

    resources = [
      aws_sns_topic.autoscaling_notifications.arn
    ]

    condition {
      test = "ArnEquals"
      variable = "aws:SourceArn"

      values = [
        aws_cloudwatch_event_rule.autoscaling_events.arn
      ]
    }

  }
}

resource "aws_sns_topic_policy" "autoscaling_notifications_policy" {
  arn = aws_sns_topic.autoscaling_notifications.arn
  policy = data.aws_iam_policy_document.autoscaling_notifications_policy.json
}
