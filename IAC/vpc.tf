resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "Main-VPC"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Main-IGW"
  }
}

resource "aws_subnet" "web" {
  vpc_id                 = aws_vpc.main.id
  cidr_block             = var.web_subnet_cidr
  availability_zone      = var.az1
  map_public_ip_on_launch = true
  tags = {
    Name = "Web-Subnet"
  }
}

resource "aws_subnet" "app" {
  vpc_id                 = aws_vpc.main.id
  cidr_block             = var.app_subnet_cidr
  availability_zone      = var.az2
  map_public_ip_on_launch = false
  tags = {
    Name = "App-Subnet"
  }
}

resource "aws_subnet" "db" {
  vpc_id                 = aws_vpc.main.id
  cidr_block             = var.db_subnet_cidr
  availability_zone      = var.az3
  map_public_ip_on_launch = false
  tags = {
    Name = "DB-Subnet"
  }
}

# Public route table for the Web subnet (for the ALB)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }

  tags = {
    Name = "Public-Route-Table"
  }
}

resource "aws_route_table_association" "web_assoc" {
  subnet_id      = aws_subnet.web.id
  route_table_id = aws_route_table.public_rt.id
}

# Private route table for App and DB subnets (no route to IGW)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "Private-Route-Table"
  }
}

resource "aws_route_table_association" "app_assoc" {
  subnet_id      = aws_subnet.app.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "db_assoc" {
  subnet_id      = aws_subnet.db.id
  route_table_id = aws_route_table.private_rt.id
}

# VPC Endpoints for SSM and related services (enables Session Manager access in private subnets)
resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc-endpoint-sg"
  description = "Security group for VPC endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VPC-Endpoint-SG"
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.app.id, aws_subnet.db.id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
}

resource "aws_vpc_endpoint" "ec2_messages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.app.id, aws_subnet.db.id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
}

resource "aws_vpc_endpoint" "ssm_messages" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type = "Interface"
  subnet_ids        = [aws_subnet.app.id, aws_subnet.db.id]
  security_group_ids = [aws_security_group.vpc_endpoint_sg.id]
}
