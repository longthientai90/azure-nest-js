output "redis_hostname" {
  value = azurerm_redis_cache.main.hostname
}
output "redis_id" {
  value = azurerm_redis_cache.main.id
}
output "primary_access_key" {
  value     = azurerm_redis_cache.main.primary_access_key
  sensitive = true
}
