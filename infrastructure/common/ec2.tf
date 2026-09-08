resource "aws_launch_template" "nodejs-launch-template" {
  name_prefix = "nodejs-launch-template"
  description = "Launch template for Node.js EC2 instances"
  image_id    = ami-0b6d9d3d33ba97d99
  instance_type = "t3.micro"

  monitoring {
    enabled = true
  }

  network_interfaces {
    associate_public_ip_address = true
    delete_on_termination = true
    security_groups = [aws_security_group.launch-template-sg]
  }
}

resource "aws_lb_target_group" "nodejs-tg" {
  name_prefix = "nodejs-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.nodejs-demo-vpc.id

  health_check {
    enabled = true
    healthy_threshold = 2
    unhealthy_threshold = 3
    interval = 30
    timeout = 5
    path = "/"
    port = 80
    protocol = "HTTP"
  }
}
resource "aws_lb" "nodejs-alb" {
  name = "nodejs-alb"
  internal = false
  load_balancer_type = "application"
  vpc_id = aws_vpc.nodejs-demo-vpc.id
  security_groups = [aws_security_group.nodejs-alb-sg]
  subnets = aws_subnet.public_subnet.*.id

  enable_deletion_protection = false
}

resource "aws_lb_listener" "nodejs-alb-listener" {
  load_balancer_arn = aws_lb.nodejs-alb.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.nodejs-tg.arn
  }

}
