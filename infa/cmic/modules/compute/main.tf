# Compute module (Container Apps)

variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "environment_name" { type = string }
variable "log_analytics_workspace_id" { type = string }
variable "subnet_id" { type = string }
variable "api_image" { type = string }
variable "web_image" { type = string }
variable "nginx_image" { type = string }
variable "postgres_host" { type = string }
variable "redis_host" { type = string }
variable "openai_endpoint" { type = string }

resource "azurerm_container_app_environment" "main" {
  name                       = "env-${var.environment_name}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = var.log_analytics_workspace_id
  infrastructure_subnet_id   = var.subnet_id
}

resource "azurerm_container_app" "api" {
  name                         = "app-api-${var.environment_name}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    min_replicas = 0
    max_replicas = 2
    container {
      name   = "api"
      image  = var.api_image
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "POSTGRES_HOST"
        value = var.postgres_host
      }
      env {
        name  = "REDIS_HOST"
        value = var.redis_host
      }
      env {
        name  = "OPENAI_ENDPOINT"
        value = var.openai_endpoint
      }
    }
  }
  ingress {
    external_enabled = false
    target_port      = 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_container_app" "web" {
  name                         = "app-web-${var.environment_name}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  template {
    min_replicas = 0
    max_replicas = 2
    container {
      name   = "web"
      image  = var.web_image
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
  ingress {
    external_enabled = false
    target_port      = 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

resource "azurerm_container_app" "nginx" {
  name                         = "app-nginx-${var.environment_name}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  template {
    min_replicas = 1
    max_replicas = 2
    container {
      name   = "nginx"
      image  = var.nginx_image
      cpu    = 0.25
      memory = "0.5Gi"
      env {
        name  = "API_URL"
        value = "https://${azurerm_container_app.api.latest_revision_fqdn}"
      }
      env {
        name  = "WEB_URL"
        value = "https://${azurerm_container_app.web.latest_revision_fqdn}"
      }
    }
  }
  ingress {
    external_enabled = true
    target_port      = 80
    traffic_weight {
      latest_revision = true
      percentage      = 100
    }
  }
}

output "container_app_environment_id" {
  value = azurerm_container_app_environment.main.id
}
output "api_fqdn" {
  value = azurerm_container_app.api.latest_revision_fqdn
}
output "web_fqdn" {
  value = azurerm_container_app.web.latest_revision_fqdn
}
output "nginx_fqdn" {
  value = azurerm_container_app.nginx.latest_revision_fqdn
}
