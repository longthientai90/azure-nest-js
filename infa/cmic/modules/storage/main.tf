# Storage module

variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "environment_name" { type = string }

resource "random_string" "storage_suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_storage_account" "main" {
  name                     = "st${var.environment_name}${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  blob_properties {
    versioning_enabled  = false
    change_feed_enabled = false
  }
}

resource "azurerm_storage_container" "images" {
  name                  = "images"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "blob"
}

resource "azurerm_storage_container" "files" {
  name                  = "files"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "blob"
}

resource "azurerm_storage_container" "nginx_config" {
  name                  = "nginx-config"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "blob"
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}
output "storage_account_id" {
  value = azurerm_storage_account.main.id
}
