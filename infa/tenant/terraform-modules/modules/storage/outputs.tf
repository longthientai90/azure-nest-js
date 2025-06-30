output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_key" {
  description = "Primary access key of the storage account"
  value       = azurerm_storage_account.main.primary_access_key
  sensitive   = true
}

output "blob_storage_url" {
  description = "Primary blob endpoint"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "app_data_container_name" {
  description = "Name of the app data container"
  value       = azurerm_storage_container.app_data.name
}

output "public_assets_container_name" {
  description = "Name of the public assets container"
  value       = azurerm_storage_container.public_assets.name
}
