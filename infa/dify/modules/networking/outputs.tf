output "container_app_subnet_id" {
  description = "ID of the container app subnet"
  value       = azurerm_subnet.container_app.id
}

output "private_endpoint_subnet_id" {
  description = "ID of the private endpoint subnet"
  value       = azurerm_subnet.private_endpoint.id
}

output "container_app_subnet_name" {
  description = "Name of the container app subnet"
  value       = azurerm_subnet.container_app.name
}

output "private_endpoint_subnet_name" {
  description = "Name of the private endpoint subnet"
  value       = azurerm_subnet.private_endpoint.name
}

output "private_dns_zone_id" {
  description = "ID của Private DNS Zone cho PostgreSQL Flexible Server"
  value       = azurerm_private_dns_zone.postgres.id
}
