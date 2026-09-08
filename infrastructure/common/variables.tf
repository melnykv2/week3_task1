variable "project_name" {
  description = "Name used for resources and tags"
  type        = string
  default     = "nodejs-demo"
}

variable "environment" {
  description = "Environment name - dev or prod"
  type = string

  validation {
    condition = contains(["dev", "production"], var.environment)
    error_message = "value must be 'dev' or 'production'"
  }
}

variable "aws_region" {
  description = "Default AWS region for the lab"
  type = string
  default = "us-west-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type = string
  default = "10.20.0.0/16"
}

variable "availability_zone_number" {
  description = "Number of AZ"
  type = number
  default = 2
}

variable "instance_type" {
  description = "Instance type used by SG"
  type = string
  default = "t3.micro"
}

variable "root_volume_size" {
  description = "Root volume size"
  type = number
  default = 8
}

variable "asg_min_size" {
  description = "Minimum size of ASG"
  type = number
  default = 1
}

variable "asg_max_size" {
  description = "Maximum size of ASG"
  type = number
  default = 5
}

variable "asg_desired_size" {
  description = "Desired size of ASG"
  type = number
  default = 2
}

variable "app_port" {
  description = "Port for NodeJS app"
  type = number
  default = 3000
}

variable "alb_port" {
  description = "HTTP listener port for alb"
  type = number
  default = 80
}

variable "docker_image" {
  description = "Docker image for EC2"
  type = string
  default = "nodejs-app:latest"
}

variable "cpu_scale_out_threshold" {
  description = "Avegare CPU that triggers scale out"
  type = number
  default = 50
}

variable "cpu_scale_in_threshold" {
  description = "Average CPU that triggers scale in"
  type = number
  default = 20
}

variable "alarm_evaluation_periods" {
  description = "Number of consecutive one-minute perdios required to trigger scaling alarms"
  type = number
  default = 2
}
