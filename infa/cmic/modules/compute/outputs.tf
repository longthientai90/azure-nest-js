output "container_app_environment_id" {
  value = azurerm_container_app_environment.main.id
}
output "api_fqdn" {
  value = azurerm_container_app.api.latest_revision_fqdn
}
output "web_fqdn" {
  value = azurerm_container_app.web.latest_revision_fqdn
}
output "nginx_fqdn" {
  value = azurerm_container_app.nginx.latest_revision_fqdn
}
