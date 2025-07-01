# Redis module

resource "random_string" "redis_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_redis_cache" "main" {
  name                          = "redis-${var.environment_name}-${random_string.redis_suffix.result}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  capacity                      = 0
  family                        = "C"
  sku_name                      = "Basic"
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false
}
