variable "aws_region" {
  description = "AWS region in which the stack will be deployed."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the application VPC."
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type = list(string)
}

variable "availability_zones" {
  description = "Availability zones for subnets"
  type = list(string)
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0fb110df4c5094d21"
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
}

variable "asg_max_size" {
  description = "Maximum number of instances in the Auto Scaling group."
  type        = number
}

variable "asg_desired_capacity" {
  description = "Initial desired number of instances in the Auto Scaling group."
  type        = number
}

variable "notification_email" {
  description = "Email address that receives CloudWatch alarm and Auto Scaling notifications."
  type        = string
}
