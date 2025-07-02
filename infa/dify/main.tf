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
  description = "Name of existing VNet"
  type        = string
}

variable "vnet_resource_group_name" {
  description = "Resource group name of existing VNet"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# Data source for existing VNet
data "azurerm_virtual_network" "existing" {
  name                = var.vnet_name
  resource_group_name = var.vnet_resource_group_name
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
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
  vnet_id             = data.azurerm_virtual_network.existing.id
  vnet_name           = data.azurerm_virtual_network.existing.name
  vnet_address_space  = data.azurerm_virtual_network.existing.address_space[0]
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
# module "compute" {
#   source = "./modules/compute"

#   environment                = var.environment
#   resource_group_name        = azurerm_resource_group.main.name
#   location                   = azurerm_resource_group.main.location
#   log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
#   container_app_subnet_id    = module.networking.container_app_subnet_id
#   storage_connection_string  = module.storage.connection_string
# }
