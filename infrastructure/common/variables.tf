variable "environment" {
  description = "Deployment environment name, for example dev or production."
  type        = string

  validation {
    condition     = contains(["dev", "production"], var.environment)
    error_message = "environment must be either dev or production."
  }
}

variable "aws_region" {
  description = "AWS region in which the stack will be deployed."
  type        = string
  default     = "us-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the application VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zone_count" {
  description = "Number of Availability Zones/public subnets used by ALB and ASG."
  type        = number
  default     = 2

  validation {
    condition     = var.availability_zone_count >= 2 && var.availability_zone_count <= 3
    error_message = "availability_zone_count must be 2 or 3."
  }
}

variable "instance_type" {
  description = "EC2 instance type used by the Auto Scaling group."
  type        = string
  default     = "t3.micro"
}

variable "asg_min_size" {
  description = "Minimum number of instances in the Auto Scaling group."
  type        = number
  default     = 1
}

variable "asg_max_size" {
  description = "Maximum number of instances in the Auto Scaling group."
  type        = number
  default     = 6
}

variable "asg_desired_capacity" {
  description = "Initial desired number of instances in the Auto Scaling group."
  type        = number
  default     = 2
}

variable "app_port" {
  description = "Port exposed by the Node.js application container."
  type        = number
  default     = 3000
}

variable "alb_port" {
  description = "Public HTTP listener port on the Application Load Balancer."
  type        = number
  default     = 80
}

variable "notification_email" {
  description = "Email address that receives CloudWatch alarm and Auto Scaling notifications."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.notification_email))
    error_message = "notification_email must be a valid email address."
  }
}

variable "cpu_scale_out_threshold" {
  description = "Average CPU percentage that triggers scale out."
  type        = number
  default     = 50
}

variable "cpu_scale_in_threshold" {
  description = "Average CPU percentage that triggers scale in."
  type        = number
  default     = 20
}

variable "alarm_evaluation_periods" {
  description = "Number of consecutive one-minute periods required to trigger scaling alarms."
  type        = number
  default     = 2
}
