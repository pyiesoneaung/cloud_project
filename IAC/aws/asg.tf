resource "aws_launch_template" "app_lt" {
  name_prefix   = "hello-world-"
  image_id      = var.ami_id
  instance_type = var.instance_type
  key_name      = var.ec2_key_name

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_ssm_profile.name
  }

  network_interfaces {
    subnet_id                   = aws_subnet.app.id
    security_groups             = [aws_security_group.ec2_sg.id]
    associate_public_ip_address = false
  }

  user_data = base64encode(<<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              echo "Hello World from $(hostname)" > /var/www/html/index.html
              systemctl start httpd
              systemctl enable httpd
              EOF
            )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                = "hello-world-asg"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 3
  vpc_zone_identifier = [aws_subnet.app.id]
  target_group_arns   = [aws_lb_target_group.app_tg.arn]
  health_check_type   = "EC2"

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "HelloWorldInstance"
    propagate_at_launch = true
  }
}
