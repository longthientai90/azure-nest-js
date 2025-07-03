output "container_app_environment_id" {
  description = "ID of the container app environment"
  value       = azurerm_container_app_environment.main.id
}

output "container_app_urls" {
  description = "URLs of the container apps"
  value = {
    nginx = "https://${azurerm_container_app.nginx.latest_revision_fqdn}"
    api   = "https://${azurerm_container_app.api.latest_revision_fqdn}"
    web   = "https://${azurerm_container_app.web.latest_revision_fqdn}"
  }
}
