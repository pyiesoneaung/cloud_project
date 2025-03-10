resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg"
  description = "Allow HTTP requests only from the ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol       = "tcp"
    from_port      = 80
    to_port        = 80
    security_groups = [aws_security_group.alb_sg.id]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EC2-SG"
  }
}
