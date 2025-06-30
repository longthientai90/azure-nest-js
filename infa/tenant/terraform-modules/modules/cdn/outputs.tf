output "cdn_profile_id" {
  description = "ID of the CDN Profile"
  value       = azurerm_cdn_profile.main.id
}

output "web_endpoint_id" {
  description = "ID of the Web CDN Endpoint"
  value       = azurerm_cdn_endpoint.web.id
}

output "assets_endpoint_id" {
  description = "ID of the Assets CDN Endpoint"
  value       = azurerm_cdn_endpoint.assets.id
}

output "endpoint_url" {
  description = "CDN endpoint URL for web app"
  value       = "https://${azurerm_cdn_endpoint.web.fqdn}"
}

output "assets_endpoint_url" {
  description = "CDN endpoint URL for static assets"
  value       = "https://${azurerm_cdn_endpoint.assets.fqdn}"
}

output "web_fqdn" {
  description = "FQDN of the web CDN endpoint"
  value       = azurerm_cdn_endpoint.web.fqdn
}

output "assets_fqdn" {
  description = "FQDN of the assets CDN endpoint"
  value       = azurerm_cdn_endpoint.assets.fqdn
}
