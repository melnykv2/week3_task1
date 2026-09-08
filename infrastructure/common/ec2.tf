resource "aws_launch_template" "nodejs-demo-launch-template" {
  name = "NodeJS Launch Template"
  image_id = ami-0fb110df4c5094d21
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

  user_data = file("../../user_data/user_data.sh")
}
