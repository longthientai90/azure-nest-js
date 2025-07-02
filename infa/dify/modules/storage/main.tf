# modules/storage/main.tf

resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Storage Account
resource "azurerm_storage_account" "main" {
  name                     = "st${var.environment}${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  # Enable blob encryption
  blob_properties {
    delete_retention_policy {
      days = 7
    }
    container_delete_retention_policy {
      days = 7
    }
    versioning_enabled = true
  }

  # Disable public access
  public_network_access_enabled = true

  # Enable private endpoint only access
  network_rules {
    default_action = "Allow"
    bypass         = ["AzureServices"]
    ip_rules       = ["210.245.54.242"] # Thêm IP của bạn vào đây
  }

  tags = {
    Environment = var.environment
    Service     = "ContainerApp"
  }
}

resource "null_resource" "wait_for_storage" {
  depends_on = [azurerm_storage_account.main]
  provisioner "local-exec" {
    command = "sleep 60" # Wait for storage account to be fully provisioned
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_role_assignment" "blob_data" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = data.azurerm_client_config.current.object_id
  depends_on           = [azurerm_storage_account.main]
}

# Blob Container
resource "azurerm_storage_container" "main" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
  depends_on            = [azurerm_storage_account.main, null_resource.wait_for_storage, azurerm_role_assignment.blob_data]
}

# Private DNS Zone for Blob Storage
resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
}

# Link Private DNS Zone to VNet
resource "azurerm_private_dns_zone_virtual_network_link" "blob" {
  name                  = "link-${var.environment}-blob"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.blob.name
  virtual_network_id    = split("/subnets/", var.subnet_id)[0] # Lấy vnet id từ subnet id
  registration_enabled  = false
}

# Private Endpoint for Blob Storage
resource "azurerm_private_endpoint" "blob" {
  name                = "pe-${var.environment}-blob"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "psc-${var.environment}-blob"
    private_connection_resource_id = azurerm_storage_account.main.id
    subresource_names              = ["blob"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [azurerm_private_dns_zone.blob.id]
  }

  tags = {
    Environment = var.environment
    Service     = "ContainerApp"
  }
}

# Get Private Endpoint IP
data "azurerm_private_endpoint_connection" "blob" {
  name                = azurerm_private_endpoint.blob.name
  resource_group_name = var.resource_group_name
  depends_on          = [azurerm_private_endpoint.blob]
}
