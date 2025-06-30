# Terraform Variables for Test Company Ltd
# Generated at: 2025-06-30T15:33:11.241280
# Company: Test Company Ltd
# Slug: test-company
# Environment: dev

# Company Information
company_name = "Test Company Ltd"
company_slug = "test-company"
environment  = "dev"

# Azure Configuration
azure_region = "Southeast Asia"

# Network Configuration
vnet_cidr           = "10.5.0.0/16"
public_subnet_cidr  = "10.5.1.0/24"
private_subnet_cidr = "10.5.2.0/24"

# Database Configuration
db_admin_username = "testadmin"

# Container Images
api_container_image = "test-registry.azurecr.io/test/api:latest"
web_container_image = "test-registry.azurecr.io/test/web:latest"