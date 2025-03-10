output "virtual_network_id" {
  description = "Azure Virtual Network ID"
  value       = azurerm_virtual_network.example.id
}

output "public_ip_address" {
  description = "Public IP address for the Virtual Network Gateway"
  value       = azurerm_public_ip.example.ip_address
}

output "vpn_gateway_id" {
  description = "ID of the Azure Virtual Network Gateway"
  value       = azurerm_virtual_network_gateway.example.id
}

output "vpn_connection_id" {
  description = "ID of the Azure VPN Connection"
  value       = azurerm_virtual_network_gateway_connection.example.id
}
