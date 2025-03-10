variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR for main VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "web_subnet_cidr" {
  description = "CIDR for web subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "app_subnet_cidr" {
  description = "CIDR for application subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR for database subnet"
  type        = string
  default     = "10.0.3.0/24"
}

variable "az1" {
  description = "Availability Zone for web subnet"
  type        = string
  default     = "us-east-1a"
}

variable "az2" {
  description = "Availability Zone for app subnet"
  type        = string
  default     = "us-east-1b"
}

variable "az3" {
  description = "Availability Zone for db subnet"
  type        = string
  default     = "us-east-1c"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0c94855ba95c71c99"  # Amazon Linux 2
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_key_name" {
  description = "Key pair name for EC2, if needed"
  type        = string
  default     = "my-keypair"  #  change with acual key
}

# VPN VPC variables
variable "vpn_vpc_cidr" {
  description = "CIDR for VPN VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "vpn_subnet_cidrs" {
  description = "List of VPN VPC subnets CIDRs"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "azure_vm_public_ip" {
  description = "Public IP of the Azure Bastion VM for IPSec tunnel"
  type        = string
  default     = "203.0.113.10"  #  later change to  Azure VM public IP
}

variable "azure_vm_access_cidr" {
  description = "Allowed CIDR for ALB access (Azure Bastion)"
  type        = string
  default     = "203.0.113.10/32"
}
