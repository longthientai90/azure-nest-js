output "id" {
  description = "ID of the Cognitive Services account"
  value       = azurerm_cognitive_account.main.id
}

output "endpoint" {
  description = "Endpoint of the Cognitive Services account"
  value       = azurerm_cognitive_account.main.endpoint
}

output "primary_access_key" {
  description = "Primary access key of the Cognitive Services account"
  value       = azurerm_cognitive_account.main.primary_access_key
  sensitive   = true
}
