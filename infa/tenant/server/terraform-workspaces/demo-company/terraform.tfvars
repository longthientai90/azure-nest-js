# Terraform Variables for Demo Company
# Generated at: 2025-06-30T15:27:57.348473
# Company: Demo Company
# Slug: demo-company
# Environment: dev

# Company Information
company_name = "Demo Company"
company_slug = "demo-company"
environment  = "dev"

# Azure Configuration
azure_region = "Southeast Asia"

# Network Configuration
vnet_cidr           = "10.99.0.0/16"
public_subnet_cidr  = "10.99.1.0/24"
private_subnet_cidr = "10.99.2.0/24"

# Database Configuration
db_admin_username = "demoadmin"

# Container Images
api_container_image = "demo.azurecr.io/demo/api:latest"
web_container_image = "demo.azurecr.io/demo/web:latest"