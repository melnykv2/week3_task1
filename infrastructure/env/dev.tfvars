aws_region  = "eu-central-1"

vpc_cidr = "10.20.0.0/16"
public_subnet_cidrs = ["10.20.1.0/24", "10.20.2.0/24"]
private_subnet_cidrs = ["10.20.3.0/24", "10.20.4.0/24"]
availability_zones = ["eu-central-1a", "eu-central-1c"]

ssh_key = "dev-key"
instance_type        = "t3.micro"
ami_id               = "ami-0303e2e4a29f041a3"
asg_min_size         = 1
asg_desired_capacity = 1
asg_max_size         = 3

notification_email = "info@vadymthebest.com"
