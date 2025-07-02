output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "nginx_url" {
  value = "https://${module.compute.nginx_fqdn}"
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

# output "postgres_connection_string" {
#   value     = "postgresql://pgadmin:P@ssw0rd123!@${module.postgres.postgres_fqdn}:5432/postgres"
#   sensitive = true
# }

# output "redis_hostname" {
#   value = module.redis.redis_hostname
# }

# output "redis_primary_key" {
#   value     = module.redis.primary_access_key
#   sensitive = true
# }

# output "openai_endpoint" {
#   value = module.openai.openai_endpoint
# }

# output "openai_key" {
#   value     = module.openai.primary_access_key
#   sensitive = true
# }
