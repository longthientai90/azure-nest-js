output "postgresql_fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgresql_connection_string" {
  value     = "postgresql://${var.admin_username}:${var.admin_password}@${azurerm_postgresql_flexible_server.main.fqdn}:5432/appdb?sslmode=require"
  sensitive = true
}
