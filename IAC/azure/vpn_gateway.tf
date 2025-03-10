# Public IP for the Virtual Network Gateway
resource "azurerm_public_ip" "example" {
  name                = "hw-pip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Dynamic"

  tags = {
    Name = "hw-pip"
  }
}

# Virtual Network Gateway
resource "azurerm_virtual_network_gateway" "example" {
  name                = "hw-vngw"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "vngw-ip"
    public_ip_address_id          = azurerm_public_ip.example.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  gateway_type = "Vpn"
  vpn_type     = "RouteBased"
  sku          = "VpnGw1"
  generation   = "Generation1"

  tags = {
    Name = "hw-vngw"
  }
}

# Local Network Gateway (representing AWS VPN)
resource "azurerm_local_network_gateway" "example" {
  name                = "example-lng"
  location            = var.location
  resource_group_name = var.resource_group_name

  gateway_address = var.aws_vpn_ip
  address_space   = var.aws_vpc_cidr

  tags = {
    Name = "hw-lng"
  }
}

# VPN Connection
resource "azurerm_virtual_network_gateway_connection" "example" {
  name                           = "hw-connection"  
  location                       = var.location
  resource_group_name            = var.resource_group_name
  virtual_network_gateway_id     = azurerm_virtual_network_gateway.example.id
  local_network_gateway_id       = azurerm_local_network_gateway.example.id
  connection_type                = "IPsec"
  vpn_type                       = "RouteBased"
  shared_key                     = var.shared_key
  enable_bgp                     = false
  use_policy_based_traffic_selectors = false

  ipsec_policy {
    sa_lifetime_seconds = 28800
    sa_datasize_kb      = 102400000
    ipsec_encryption    = "AES256"
    ipsec_integrity     = "SHA256"
    ike_encryption      = "AES256"
    ike_integrity       = "SHA256"
    dh_group            = "DHGroup14"
    pfs_group           = "PFS2"
  }

  tags = {
    Name = "hw-connection"
  }
}
