# Hello World Application Deployment

## AWS Setup

This project sets up the following AWS infrastructure using Terraform:
- A non-default VPC with custom subnets for web, application, and database tiers.
- EC2 instances managed by an Auto Scaling Group.
- Application Load Balancer for high availability.
- Security groups and NACLs for traffic control.
- AWS Backup for resilience.
- Lambda functions for cost optimization (automatically start/stop instances).
- VPN IPSec tunnel setup with Azure using Transit Gateway.

## Azure Setup

This project sets up the following Azure infrastructure using Terraform:
- Azure Virtual Network with subnets.
- Virtual Network Gateway for VPN connectivity to AWS.
- VPN connection to AWS Transit Gateway.

## CI/CD Pipeline

GitHub Actions is used for CI/CD to manage both AWS and Azure Terraform configurations. 

## Getting Started

1. Initialize Terraform:
   ```sh
   terraform init
