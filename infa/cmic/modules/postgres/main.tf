# Postgres module

variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "environment_name" { type = string }

resource "random_string" "db_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_postgresql_flexible_server" "main" {
  name                         = "psql-${var.environment_name}-${random_string.db_suffix.result}"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "13"
  sku_name                     = "B_Standard_B1ms"
  storage_mb                   = 32768
  backup_retention_days        = 7
  geo_redundant_backup_enabled = false
  administrator_login          = "pgadmin"
  administrator_password       = "P@ssw0rd123!"
  zone                         = "1"
  # Các thuộc tính subnet và private DNS sẽ truyền từ ngoài vào nếu cần
}

output "postgres_fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}
output "postgres_id" {
  value = azurerm_postgresql_flexible_server.main.id
}
