resource "aws_sns_topic" "nodejs_sns_topic" {
  name = "cpu_alarm_topic"
}

resource "aws_sns_topic_subscription" "nodejs_sns_topic_subscription" {
  topic_arn = aws_sns_topic.nodejs_sns_topic.arn
  protocol = "email"
  endpoint = "info@vadymthebest.com"
}
