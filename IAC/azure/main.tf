provider "azurerm" {
  features {}
}

module "virtual_network" {
  source              = "./virtual_network.tf"
  resource_group_name = azurerm_resource_group.hw.name
  location            = azurerm_resource_group.hw.location
}

module "vpn_gateway" {
  source                = "./vpn_gateway.tf"
  resource_group_name   = azurerm_resource_group.hw.name
  location              = azurerm_resource_group.hw.location
  virtual_network_id    = module.virtual_network.virtual_network_id
  subnet_id             = module.virtual_network.subnet_id
  azure_vm_public_ip    = var.azure_vm_public_ip
  aws_vpn_ip            = var.aws_vpn_ip
  aws_vpc_cidr          = var.aws_vpc_cidr
  shared_key            = var.shared_key
}

# Resource Group
resource "azurerm_resource_group" "hw" {
  name     = var.resource_group_name
  location = var.location
}
