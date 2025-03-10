# VPN Termination VPC
resource "aws_vpc" "vpn" {
  cidr_block           = var.vpn_vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "VPN-VPC"
  }
}

resource "aws_internet_gateway" "vpn_igw" {
  vpc_id = aws_vpc.vpn.id

  tags = {
    Name = "VPN-IGW"
  }
}

resource "aws_subnet" "vpn" {
  count              = length(var.vpn_subnet_cidrs)
  vpc_id             = aws_vpc.vpn.id
  cidr_block         = element(var.vpn_subnet_cidrs, count.index)
  availability_zone  = element(var.azs, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "VPN-Subnet-${count.index + 1}"
  }
}

# Transit Gateway for connecting both VPCs
resource "aws_ec2_transit_gateway" "tgw" {
  description = "Transit Gateway for VPN termination"
  tags = {
    Name = "Main-Transit-Gateway"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "main_vpc_attachment" {
  vpc_id             = aws_vpc.main.id
  subnet_ids         = [aws_subnet.web.id, aws_subnet.app.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "Main-VPC-Attachment"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "vpn_vpc_attachment" {
  vpc_id             = aws_vpc.vpn.id
  subnet_ids         = [for s in aws_subnet.vpn : s.id]
  transit_gateway_id = aws_ec2_transit_gateway.tgw.id

  tags = {
    Name = "VPN-VPC-Attachment"
  }
}

# Customer Gateway representing Azure Bastion
resource "aws_customer_gateway" "azure" {
  bgp_asn    = 65000
  ip_address = var.azure_vm_public_ip
  type       = "ipsec.1"
  tags = {
    Name = "Azure-Bastion-CG"
  }
}

resource "aws_vpn_connection" "vpn_connection" {
  transit_gateway_id  = aws_ec2_transit_gateway.tgw.id
  customer_gateway_id = aws_customer_gateway.azure.id
  type                = "ipsec.1"
  static_routes_only  = false

  tags = {
    Name = "Azure-to-AWS-VPN"
  }
}
