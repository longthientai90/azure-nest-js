
# Company-specific Terraform configuration
# Generated for: Demo Company
# Company Slug: demo-company
# Environment: dev
# Generated at: 2025-06-30T15:27:57.348473

terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "terraform-state-rg"
    storage_account_name = "terraformstatestorage"
    container_name       = "tfstate"
    key                  = "companies/demo-company/terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  
  subscription_id = "None"
  tenant_id      = "None"
  client_id      = "None"
  client_secret  = "None"
}

# Variables
variable "company_name" {
  description = "Company name"
  type        = string
  default     = "Demo Company"
}

variable "company_slug" {
  description = "Company slug"
  type        = string
  default     = "demo-company"
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = "dev"
}

variable "azure_region" {
  description = "Azure region"
  type        = string
  default     = "Southeast Asia"
}

variable "vnet_cidr" {
  description = "VNet CIDR"
  type        = string
  default     = "10.99.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.99.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
  default     = "10.99.2.0/24"
}

variable "db_admin_username" {
  description = "Database admin username"
  type        = string
  default     = "demoadmin"
}

variable "api_container_image" {
  description = "API container image"
  type        = string
  default     = "demo.azurecr.io/demo/api:latest"
}

variable "web_container_image" {
  description = "Web container image"
  type        = string
  default     = "demo.azurecr.io/demo/web:latest"
}

# Include the main module
module "company_infrastructure" {
  source = "../../"
  
  company_name         = var.company_name
  company_slug         = var.company_slug
  environment          = var.environment
  azure_region         = var.azure_region
  vnet_cidr           = var.vnet_cidr
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
  db_admin_username   = var.db_admin_username
  api_container_image = var.api_container_image
  web_container_image = var.web_container_image
}

# Outputs
output "company_infrastructure" {
  description = "All infrastructure outputs"
  value = {
    resource_group_name    = module.company_infrastructure.resource_group_name
    resource_group_id      = module.company_infrastructure.resource_group_id
    vnet_id               = module.company_infrastructure.vnet_id
    public_subnet_id      = module.company_infrastructure.public_subnet_id
    private_subnet_id     = module.company_infrastructure.private_subnet_id
    database_fqdn         = module.company_infrastructure.database_fqdn
    database_name         = module.company_infrastructure.database_name
    storage_account_name  = module.company_infrastructure.storage_account_name
    blob_storage_url      = module.company_infrastructure.blob_storage_url
    ai_services_endpoint  = module.company_infrastructure.ai_services_endpoint
    api_app_url          = module.company_infrastructure.api_app_url
    web_app_url          = module.company_infrastructure.web_app_url
    cdn_endpoint_url     = module.company_infrastructure.cdn_endpoint_url
    key_vault_id         = module.company_infrastructure.key_vault_id
  }
  sensitive = true
}