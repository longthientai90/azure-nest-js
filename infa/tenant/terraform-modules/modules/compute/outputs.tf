output "container_app_environment_id" {
  description = "ID of the Container App Environment"
  value       = azurerm_container_app_environment.main.id
}

output "api_app_id" {
  description = "ID of the API Container App"
  value       = azurerm_container_app.api.id
}

output "web_app_id" {
  description = "ID of the Web Container App"
  value       = azurerm_container_app.web.id
}

output "api_app_url" {
  description = "URL of the API Container App"
  value       = "https://${azurerm_container_app.api.latest_revision_fqdn}"
}

output "web_app_url" {
  description = "URL of the Web Container App"
  value       = "https://${azurerm_container_app.web.latest_revision_fqdn}"
}

output "api_fqdn" {
  description = "FQDN of the API Container App"
  value       = azurerm_container_app.api.latest_revision_fqdn
}

output "web_fqdn" {
  description = "FQDN of the Web Container App"
  value       = azurerm_container_app.web.latest_revision_fqdn
}
