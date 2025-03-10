variable "location" {
  description = "Azure region"
  default     = "East US"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  default     = "hw-resources"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network name"
  default     = "hw-vnet"
  type        = string
}

variable "address_space" {
  description = "Address space for the Virtual Network"
  default     = ["10.2.0.0/16"]
  type        = list(string)
}

variable "subnet_name" {
  description = "Subnet name for the Gateway"
  default     = "GatewaySubnet"
  type        = string
}

variable "subnet_address_prefix" {
  description = "Address prefix for the Gateway Subnet"
  default     = ["10.2.0.0/24"]
  type        = list(string)
}

variable "aws_vpn_ip" {
  description = "AWS VPN endpoint IP"
  default     = "hw-aws-vpn-ip"
  type        = string
}

variable "aws_vpc_cidr" {
  description = "AWS VPC CIDR"
  default     = ["10.0.0.0/16"]
  type        = list(string)
}

variable "shared_key" {
  description = "Pre-shared key for the VPN connection"
  default     = "hw-shared-key"
  type        = string
}
