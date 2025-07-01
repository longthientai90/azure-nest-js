terraform {
}

provider "azurerm" {
  features {}
}

# Local values for consistent naming
locals {
  common_tags = {
    Company     = var.company_name
    CompanySlug = var.company_slug
    Environment = var.environment
    ManagedBy   = "terraform"
    CreatedAt   = timestamp()
  }

  resource_prefix = "${var.company_slug}-${var.environment}"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "${local.resource_prefix}-rg"
  location = var.azure_region
  tags     = local.common_tags
}

# Random password for database
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Key Vault for storing secrets
resource "azurerm_key_vault" "main" {
  name                = "${local.resource_prefix}-kv"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore"
    ]
  }

  tags = local.common_tags
}

# Store database password in Key Vault
resource "azurerm_key_vault_secret" "db_password" {
  name         = "db-admin-password"
  value        = random_password.db_password.result
  key_vault_id = azurerm_key_vault.main.id
}

data "azurerm_client_config" "current" {}

# Networking Module
module "networking" {
  source = "./modules/networking"

  company_slug        = var.company_slug
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  vnet_cidr           = var.vnet_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr

  tags = local.common_tags
}

# Database Module
module "database" {
  count  = var.enable_database ? 1 : 0
  source = "./modules/database"

  company_slug        = var.company_slug
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.networking.private_subnet_id
  admin_username      = var.db_admin_username
  admin_password      = random_password.db_password.result

  tags = local.common_tags
}

# Storage Module  
module "storage" {
  source = "./modules/storage"

  company_slug        = var.company_slug
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = local.common_tags
}

# AI Services Module
module "ai_services" {
  count  = var.enable_ai_services ? 1 : 0
  source = "./modules/ai"

  company_slug        = var.company_slug
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  tags = local.common_tags
}

# Container Apps Module
module "compute" {
  source = "./modules/compute"

  company_slug        = var.company_slug
  environment         = var.environment
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.networking.private_subnet_id

  # Database connection
  database_host     = var.enable_database ? module.database[0].fqdn : ""
  database_name     = var.enable_database ? module.database[0].database_name : ""
  database_username = var.db_admin_username
  database_password = random_password.db_password.result

  # Storage connection
  storage_account_name = module.storage.storage_account_name
  storage_account_key  = module.storage.storage_account_key

  # AI Services connection
  ai_services_endpoint = var.enable_ai_services ? module.ai_services[0].endpoint : ""
  ai_services_key      = var.enable_ai_services ? module.ai_services[0].primary_access_key : ""

  # Container images
  api_image = var.api_container_image
  web_image = var.web_container_image

  tags = local.common_tags
}

# CDN Module
module "cdn" {
  count  = var.enable_cdn_services ? 1 : 0
  source = "./modules/cdn"

  company_slug         = var.company_slug
  environment          = var.environment
  resource_group_name  = azurerm_resource_group.main.name
  location             = azurerm_resource_group.main.location
  origin_url           = module.compute.web_app_url
  storage_account_name = module.storage.storage_account_name

  tags = local.common_tags
}
