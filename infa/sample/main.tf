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

# Variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-containerapp-demo"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Southeast Asia"
}

variable "vnet_name" {
  description = "Name of the VNet"
  type        = string
  default     = "vnet-containerapp-demo"
}

variable "vnet_address_space" {
  description = "Address space for the VNet (CIDR block)"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Create Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

# Log Analytics Workspace for Container Apps
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-${var.environment}-containerapp"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  vnet_id             = azurerm_virtual_network.main.id
  vnet_name           = azurerm_virtual_network.main.name
  vnet_address_space  = var.vnet_address_space
  environment         = var.environment
}

# Storage Module
module "storage" {
  source = "./modules/storage"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  subnet_id           = module.networking.private_endpoint_subnet_id
  environment         = var.environment

  depends_on = [module.networking]
}

# Compute module
module "compute" {
  source = "./modules/compute"

  environment                = var.environment
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  container_app_subnet_id    = module.networking.container_app_subnet_id
  storage_connection_string  = module.storage.connection_string
  postgres_connection_string = module.database.postgresql_connection_string
}

# Database module
module "database" {
  source = "./modules/database"

  environment                = var.environment
  resource_group_name        = azurerm_resource_group.main.name
  location                   = azurerm_resource_group.main.location
  admin_username             = "psqladminuser"       # Thay bằng giá trị thực tế hoặc biến
  admin_password             = var.db_admin_password # Nên khai báo biến này ở file tfvars hoặc secrets
  private_endpoint_subnet_id = module.networking.private_endpoint_subnet_id
  private_dns_zone_id        = module.networking.private_dns_zone_id

  depends_on = [module.networking]
}
