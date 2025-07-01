output "virtual_network_id" {
  value = azurerm_virtual_network.main.id
}

output "subnet_container_apps_id" {
  value = azurerm_subnet.container_apps.id
}

output "subnet_private_endpoints_id" {
  value = azurerm_subnet.private_endpoints.id
}

output "private_dns_zone_postgres_id" {
  value = azurerm_private_dns_zone.postgres.id
}

output "private_dns_zone_redis_id" {
  value = azurerm_private_dns_zone.redis.id
}

output "private_dns_zone_openai_id" {
  value = azurerm_private_dns_zone.openai.id
}
