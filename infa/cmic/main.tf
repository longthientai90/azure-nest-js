terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Log Analytics Workspace (bắt buộc cho Container Apps)
resource "azurerm_log_analytics_workspace" "main" {
  name                = "log-${var.environment_name}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30 # Tối thiểu để tiết kiệm chi phí
}

# Container Apps Environment
resource "azurerm_container_app_environment" "main" {
  name                       = "env-${var.environment_name}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  infrastructure_subnet_id   = module.networking.subnet_container_apps_id
}

module "storage" {
  source              = "./modules/storage"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment_name    = var.environment_name
}

# module "redis" {
#   source              = "./modules/redis"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   environment_name    = var.environment_name
# }

# module "postgres" {
#   source              = "./modules/postgres"
#   resource_group_name = azurerm_resource_group.main.name
#   location            = azurerm_resource_group.main.location
#   environment_name    = var.environment_name
# }

# module "openai" {
#   source              = "./modules/openai"
#   resource_group_name = azurerm_resource_group.main.name
#   environment_name    = var.environment_name
# }

module "compute" {
  source                     = "./modules/compute"
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  environment_name           = var.environment_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  subnet_id                  = module.networking.subnet_container_apps_id
  api_image                  = "nginx:alpine" # Thay bằng image thực tế
  web_image                  = "nginx:alpine" # Thay bằng image thực tế
  nginx_image                = "nginx:alpine" # Thay bằng image thực tế
  # postgres_host              = module.postgres.postgres_fqdn
  # redis_host                 = module.redis.redis_hostname
  # openai_endpoint            = module.openai.openai_endpoint
}

module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment_name    = var.environment_name
}

# Sử dụng output của module networking cho các module khác
# subnet_id = module.networking.subnet_container_apps_id
# private_dns_zone_postgres_id = module.networking.private_dns_zone_postgres_id
# ...
