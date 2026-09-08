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
}

resource "aws_lb_target_group" "Nodejs-Target-Group" {
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
}
