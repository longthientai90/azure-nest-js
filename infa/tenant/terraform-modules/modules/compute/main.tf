# Container Apps Environment
resource "azurerm_container_app_environment" "main" {
  name                     = "${var.company_slug}-${var.environment}-cae"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  infrastructure_subnet_id = var.subnet_id

  tags = var.tags
}

# Log Analytics Workspace for Container Apps
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.company_slug}-${var.environment}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

# API Container App
resource "azurerm_container_app" "api" {
  name                         = "${var.company_slug}-${var.environment}-api"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "api"
      image  = var.api_image
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "DATABASE_HOST"
        value = var.database_host
      }

      env {
        name  = "DATABASE_NAME"
        value = var.database_name
      }

      env {
        name  = "DATABASE_USERNAME"
        value = var.database_username
      }

      env {
        name        = "DATABASE_PASSWORD"
        secret_name = "database-password"
      }

      env {
        name  = "STORAGE_ACCOUNT_NAME"
        value = var.storage_account_name
      }

      env {
        name        = "STORAGE_ACCOUNT_KEY"
        secret_name = "storage-account-key"
      }

      env {
        name  = "AI_SERVICES_ENDPOINT"
        value = var.ai_services_endpoint
      }

      env {
        name        = "AI_SERVICES_KEY"
        secret_name = "ai-services-key"
      }
    }

    min_replicas = 1
    max_replicas = 3
  }

  secret {
    name  = "database-password"
    value = var.database_password
  }

  secret {
    name  = "storage-account-key"
    value = var.storage_account_key
  }

  secret {
    name  = "ai-services-key"
    value = var.ai_services_key
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 8080

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  tags = var.tags
}

# Web Container App
resource "azurerm_container_app" "web" {
  name                         = "${var.company_slug}-${var.environment}-web"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "web"
      image  = var.web_image
      cpu    = 0.25
      memory = "0.5Gi"

      env {
        name  = "API_URL"
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

  tags = var.tags
}
