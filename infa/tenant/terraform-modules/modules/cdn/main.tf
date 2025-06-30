# CDN Profile
resource "azurerm_cdn_profile" "main" {
  name                = "${var.company_slug}-${var.environment}-cdn"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard_Microsoft"

  tags = var.tags
}

# CDN Endpoint for Web App
resource "azurerm_cdn_endpoint" "web" {
  name                = "${var.company_slug}-${var.environment}-web-cdn"
  profile_name        = azurerm_cdn_profile.main.name
  location            = var.location
  resource_group_name = var.resource_group_name

  origin {
    name      = "web-origin"
    host_name = replace(var.origin_url, "https://", "")
  }

  origin_host_header = replace(var.origin_url, "https://", "")

  delivery_rule {
    name  = "EnforceHTTPS"
    order = 1

    request_scheme_condition {
      operator         = "Equal"
      negate_condition = false
      match_values     = ["HTTP"]
    }

    url_redirect_action {
      redirect_type = "Found"
      protocol      = "Https"
    }
  }

  tags = var.tags
}

# CDN Endpoint for Static Assets
resource "azurerm_cdn_endpoint" "assets" {
  name                = "${var.company_slug}-${var.environment}-assets-cdn"
  profile_name        = azurerm_cdn_profile.main.name
  location            = var.location
  resource_group_name = var.resource_group_name

  origin {
    name      = "storage-origin"
    host_name = "${var.storage_account_name}.blob.core.windows.net"
  }

  origin_path = "/public-assets"

  delivery_rule {
    name  = "CacheRule"
    order = 1

    request_uri_condition {
      operator         = "Contains"
      negate_condition = false
      match_values     = [".css", ".js", ".png", ".jpg", ".jpeg", ".gif", ".ico", ".svg"]
    }

    cache_expiration_action {
      behavior = "Override"
      duration = "1.00:00:00"
    }
  }

  tags = var.tags
}
