resource "aws_launch_template" "nodejs-demo-launch-template" {
  name = "NodeJS-Launch-Template"
  image_id = "ami-0fb110df4c5094d21"
  instance_type = "t3.micro"
  update_default_version = true
  key_name = "nodejs-demo"

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination = true
    security_groups = [aws_security_group.launch-template-sg.id]
  }

  user_data = base64encode(file("../../user_data/user_data.sh"))

  tags = {
    Name = "NodeJS-Launch-Template"
  }
}

resource "aws_lb_target_group" "nodejs-target-group" {
  name = "Nodejs-Target-Group"
  port = 80
  protocol = "HTTP"
  target_type = "instance"
  vpc_id = aws_vpc.nodejs-demo-vpc.id

  health_check {
    enabled = true
    healthy_threshold = 3
    unhealthy_threshold = 3
    matcher = "200-399"
    path = "/"
    port = "80"
    protocol = "HTTP"
    interval = 15
    timeout = 5
  }

  tags = {
    Name = "NodeJS-Target-Group"
  }
}

resource "aws_lb" "nodejs-alb" {
  name = "NodeJS-Load-Balancer"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb-sg.id]
  subnets = [
    aws_subnet.public_subnet_a.id,
    aws_subnet.public_subnet_c.id
  ]

  tags = {
    Name = "NodeJS-Load-Balancer"
  }
}

resource "aws_lb_listener" "nodejs-alb-listener" {
  load_balancer_arn = aws_lb.nodejs-alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nodejs-target-group.arn
  }

  tags = {
    Name = "NodeJS-ALB-Listener"
  }
}

module "nodejs-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "9.3.1"
  name = "NodeJS-ASG"
  instance_name = "NodeJS-Instance"

  min_size = var.asg_min_size
  max_size = var.asg_max_size
  desired_capacity = var.asg_desired_capacity
  wait_for_capacity_timeout = "5m"
  default_instance_warmup = 150
  health_check_type = "ELB"
  vpc_zone_identifier = [
    aws_subnet.private_subnet_a.id,
    aws_subnet.private_subnet_c.id
  ]

  create_launch_template = false
  launch_template_id = aws_launch_template.nodejs-demo-launch-template.id
  launch_template_version = aws_launch_template.nodejs-demo-launch-template.latest_version

  traffic_source_attachments = {
    nodejs-alb = {
      traffic_source_identifier = aws_lb_target_group.nodejs-target-group.arn
      traffic_source_type = "elbv2"
    }
  }

  default_cooldown = 200

  scaling_policies = {
    nodejs-scaling-policy = {
      policy_type = "TargetTrackingScaling"
      target_tracking_configuration = {
        predefined_metric_specification = {
          predefined_metric_type = "ASGAverageCPUUtilization"
        }
        target_value = var.cpu_scale_out_threshold
        estimated_instance_warmup = 150
      }
    }
  }

  tags = {
    Name = "NodeJS-ASG"
  }
}
