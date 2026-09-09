output "vpc_id" {
  description = "VPC ID"
  value = aws_vpc.nodejs-demo-vpc.id
}

output "publc_subnet_ids" {
  description = "Public subnet IDs"
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value = aws_subnet.private_subnet[*].id
}

output "load_balancer_dns_name" {
  description = "Load balancer DNS name"
  value = aws_lb.nodejs-alb.dns_name
}

output "load_balancer_url" {
  description = "Load Balancer URL"
  value = "http://${aws_lb.nodejs-alb.dns_name}"
}

output "autoscaling_group_name" {
  description = "Autoscaling group name"
  value = module.nodejs-asg.autoscaling_group_name
}

output "sns_topic_arn" {
  description = "SNS topic ARN"
  value = aws_sns_topic.autoscaling_notifications.arn
}
