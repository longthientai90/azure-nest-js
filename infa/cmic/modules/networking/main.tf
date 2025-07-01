# Networking module

variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "environment_name" { type = string }

resource "azurerm_virtual_network" "vnet_cmic" {
  name                = "vnet-${var.environment_name}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "container_apps" {
  name                 = "subnet-containerapps"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_cmic.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "Microsoft.App.environments"
    service_delegation {
      name = "Microsoft.App/environments"
    }
  }
}

resource "azurerm_subnet" "private_endpoints" {
  name                 = "subnet-private-endpoints"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_cmic.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Private DNS Zones
resource "azurerm_private_dns_zone" "postgres" {
  name                = "privatelink.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}
resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
  name                  = "postgres-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.postgres.name
  virtual_network_id    = azurerm_virtual_network.vnet_cmic.id
}
resource "azurerm_private_dns_zone" "redis" {
  name                = "privatelink.redis.cache.windows.net"
  resource_group_name = var.resource_group_name
}
resource "azurerm_private_dns_zone_virtual_network_link" "redis" {
  name                  = "redis-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.redis.name
  virtual_network_id    = azurerm_virtual_network.vnet_cmic.id
}
resource "azurerm_private_dns_zone" "openai" {
  name                = "privatelink.openai.azure.com"
  resource_group_name = var.resource_group_name
}
resource "azurerm_private_dns_zone_virtual_network_link" "openai" {
  name                  = "openai-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.openai.name
  virtual_network_id    = azurerm_virtual_network.vnet_cmic.id
}

output "virtual_network_id" {
  value = azurerm_virtual_network.vnet_cmic.id
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
