aws_region  = "us-west-1"

vpc_cidr = "10.30.0.0/16"

public_subnet_cidrs = ["10.30.1.0/24", "10.30.2.0/24"]
private_subnet_cidrs = ["10.30.3.0/24", "10.30.4.0/24"]
availability_zones = ["us-west-1a", "us-west-1c"]

instance_type        = "t3.micro"
ami_id               = "ami-0fb110df4c5094d21"
asg_min_size         = 2
asg_desired_capacity = 2
asg_max_size         = 6

notification_email = "info@vadymthebest.com"
