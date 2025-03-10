# Virtual Network
resource "azurerm_virtual_network" "example" {
  name                = var.vnet_name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    Name = "example-vnet"
  }
}

# Subnet for the Virtual Network Gateway
resource "azurerm_subnet" "example" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_virtual_network.example.resource_group_name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = var.subnet_address_prefix

  tags = {
    Name = "example-subnet"
  }
}
