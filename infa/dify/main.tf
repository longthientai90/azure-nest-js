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

# Container App Environment
resource "azurerm_container_app_environment" "main" {
  name                       = "cae-${var.environment}"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  infrastructure_subnet_id = module.networking.container_app_subnet_id
}

# Container Apps
resource "azurerm_container_app" "nginx" {
  name                         = "ca-nginx-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "nginx"
      image  = "nginx:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }

    min_replicas = 1
    max_replicas = 3
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

resource "azurerm_container_app" "api" {
  name                         = "ca-api-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "api"
      image  = "nginx:latest" # Thay thế bằng API image của bạn
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "STORAGE_CONNECTION_STRING"
        value = module.storage.connection_string
      }
    }

    min_replicas = 1
    max_replicas = 5
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

resource "azurerm_container_app" "web" {
  name                         = "ca-web-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = azurerm_resource_group.main.name
  revision_mode                = "Single"

  template {
    container {
      name   = "web"
      image  = "nginx:latest" # Thay thế bằng web image của bạn
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "API_ENDPOINT"
        value = "https://${azurerm_container_app.api.latest_revision_fqdn}"
      }
    }

    min_replicas = 1
    max_replicas = 3
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 80

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }
}

# Outputs
output "container_app_urls" {
  description = "URLs of the container apps"
  value = {
    nginx = "https://${azurerm_container_app.nginx.latest_revision_fqdn}"
    api   = "https://${azurerm_container_app.api.latest_revision_fqdn}"
    web   = "https://${azurerm_container_app.web.latest_revision_fqdn}"
  }
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = module.storage.storage_account_name
}

output "private_endpoint_ip" {
  description = "Private endpoint IP address"
  value       = module.storage.private_endpoint_ip
}
