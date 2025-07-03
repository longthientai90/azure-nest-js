# Azure Database for PostgreSQL with Private Endpoint

resource "azurerm_postgresql_flexible_server" "main" {
  name                          = "psql-${var.environment}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  version                       = "13"
  administrator_login           = var.admin_username
  administrator_password        = var.admin_password
  storage_mb                    = 32768
  sku_name                      = "B_Standard_B1ms"
  delegated_subnet_id           = var.private_endpoint_subnet_id
  private_dns_zone_id           = var.private_dns_zone_id
  zone                          = "1"
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  public_network_access_enabled = false
}

resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "appdb"
  server_id = azurerm_postgresql_flexible_server.main.id
  collation = "en_US.utf8"
  charset   = "UTF8"
}

resource "azurerm_private_endpoint" "main" {
  name                = "pe-psql-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "psc-psql-${var.environment}"
    private_connection_resource_id = azurerm_postgresql_flexible_server.main.id
    is_manual_connection           = false
    subresource_names              = ["postgresqlServer"]
  }
}

output "postgresql_fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgresql_connection_string" {
  value     = "postgresql://${var.admin_username}:${var.admin_password}@${azurerm_postgresql_flexible_server.main.fqdn}:5432/appdb?sslmode=require"
  sensitive = true
}
