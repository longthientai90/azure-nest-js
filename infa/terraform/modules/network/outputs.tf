output "nat_ip_id" {
  description = "The ID of the NAT Public IP"
  value       = azurerm_public_ip.nat_ip.id
}

output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = azurerm_nat_gateway.nat.id
}
