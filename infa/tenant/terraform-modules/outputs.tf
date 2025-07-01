output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.main.id
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = module.networking.vnet_id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.networking.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.networking.private_subnet_id
}

output "database_fqdn" {
  description = "FQDN of the PostgreSQL server"
  value       = length(module.database) > 0 ? module.database[0].fqdn : ""
  sensitive   = true
}

output "database_name" {
  description = "Name of the database"
  value       = length(module.database) > 0 ? module.database[0].database_name : ""
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage.storage_account_name
}

output "blob_storage_url" {
  description = "URL of the blob storage"
  value       = module.storage.blob_storage_url
}

output "ai_services_endpoint" {
  description = "AI Services endpoint"
  value       = length(module.ai_services) > 0 ? module.ai_services[0].endpoint : ""
  sensitive   = true
}

output "api_app_url" {
  description = "API application URL"
  value       = module.compute.api_app_url
}

output "web_app_url" {
  description = "Web application URL"
  value       = module.compute.web_app_url
}

output "cdn_endpoint_url" {
  description = "CDN endpoint URL"
  value       = length(module.cdn) > 0 ? module.cdn[0].endpoint_url : ""
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}
