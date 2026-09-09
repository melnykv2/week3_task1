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

variable "public_subnet_a" {
  description = "CIDR block for the public subnet A."
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_c" {
  description = "CIDR block for the public subnet C"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_a" {
  description = "CIDR block for the private subnet A"
  type        = string
  default     = "10.0.11.0/24"
}

variable "private_subnet_c" {
  description = "CIDR block for the private subnet C"
  type        = string
  default     = "10.0.22.0/24"
}

variable "az_a" {
  description = "AZ for subnets A"
  type        = string
  default     = "us-west-1a"
}

variable "az_c" {
  description = "AZ for subnets C"
  type        = string
  default     = "us-west-1c"
}

variable "az_c" {
  description = "AZ for subnets C"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type used by the Auto Scaling group."
  type        = string
  default     = "t3.micro"
}

variable "node_key" {
  description = "Name of the SSH key pair for the Node.js instances."
  type        = string
  default     = "nodejs-demo"
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
/*
variable "cpu_scale_in_threshold" {
  description = "Average CPU percentage that triggers scale in."
  type        = number
  default     = 20
}
*/
variable "alarm_evaluation_periods" {
  description = "Number of consecutive one-minute periods required to trigger scaling alarms."
  type        = number
  default     = 2
}
