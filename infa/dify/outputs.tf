output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage.storage_account_name
}

output "private_endpoint_ip" {
  description = "Private endpoint IP address"
  value       = module.storage.private_endpoint_ip
}
