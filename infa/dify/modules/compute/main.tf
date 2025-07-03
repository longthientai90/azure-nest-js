# Compute module for Azure resources (empty, to be filled as needed)

# Container App Environment
resource "azurerm_container_app_environment" "main" {
  name                       = "cae-${var.environment}-1"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  infrastructure_subnet_id   = var.container_app_subnet_id

  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    maximum_count         = 10
    minimum_count         = 0
  }
}

# Container Apps
resource "azurerm_container_app" "nginx" {
  name                         = "ca-nginx-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
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
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name   = "api"
      image  = "nginx:latest" # Thay thế bằng API image của bạn
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "STORAGE_CONNECTION_STRING"
        value = var.storage_connection_string
      }
      env {
        name  = "POSTGRES_CONNECTION_STRING"
        value = var.postgres_connection_string
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
  resource_group_name          = var.resource_group_name
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
