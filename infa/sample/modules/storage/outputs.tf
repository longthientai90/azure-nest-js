output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "connection_string" {
  description = "Connection string for the storage account"
  value       = azurerm_storage_account.main.primary_connection_string
  sensitive   = true
}

output "blob_endpoint" {
  description = "Blob endpoint URL"
  value       = azurerm_storage_account.main.primary_blob_endpoint
}

output "container_name" {
  description = "Name of the blob container"
  value       = azurerm_storage_container.main.name
}

output "private_endpoint_ip" {
  description = "Private endpoint IP address"
  value       = data.azurerm_private_endpoint_connection.blob.private_service_connection[0].private_ip_address
}

output "private_dns_zone_name" {
  description = "Private DNS zone name"
  value       = azurerm_private_dns_zone.blob.name
}
