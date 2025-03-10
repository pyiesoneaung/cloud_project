provider "aws" {
  region = var.region
}

# Backend configuration
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "global/s3/terraform.tfstate"
    region         = var.region
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

# Include VPC and Subnet Definitions
module "vpc" {
  source = "./vpc.tf"
}

# Include Application Load Balancer Configuration
module "alb" {
  source = "./alb.tf"

  vpc_id         = module.vpc.vpc_id
  web_subnet_id  = module.vpc.web_subnet_id
}

# Include Auto Scaling Group and EC2 Instances
module "asg" {
  source = "./asg.tf"

  vpc_id          = module.vpc.vpc_id
  app_subnet_id   = module.vpc.app_subnet_id
  instance_type   = var.instance_type
  ami_id          = var.ami_id
  ec2_key_name    = var.ec2_key_name
  alb_target_arn  = module.alb.app_tg_arn
}

# Security Groups for Load Balancer and EC2 Instances
module "security_groups" {
  source = "./security_groups.tf"

  vpc_id         = module.vpc.vpc_id
  web_subnet_id  = module.vpc.web_subnet_id
}

# IAM Roles and Instance Profiles
module "iam" {
  source = "./iam.tf"
}

# Lambda Functions for Scheduling Start/Stop
module "lambda" {
  source = "./lambda.tf"

  iam_role_arn  = module.iam.lambda_exec_role_arn
}

# VPN IPSec Tunnel Configuration with Transit Gateway
module "vpn" {
  source = "./vpn.tf"

  vpc_id          = module.vpc.vpc_id
  vpn_vpc_id      = module.vpc.vpn_vpc_id
  transit_gateway_id  = module.vpc.transit_gateway_id
  azure_vm_public_ip  = var.azure_vm_public_ip
}

# AWS Backup Configuration
module "backup" {
  source = "./backup.tf"

  iam_role_arn  = module.iam.lambda_exec_role_arn
}

# Variables Definition
variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-0c94855ba95c71c99"
}

variable "ec2_key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
  default     = "my-keypair"
}

variable "azure_vm_public_ip" {
  description = "Public IP of the Azure VM acting as Bastion"
  type        = string
  default     = "203.0.113.10"
}


