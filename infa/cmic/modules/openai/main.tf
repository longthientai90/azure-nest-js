# OpenAI module

resource "azurerm_cognitive_account" "openai" {
  name                          = "openai-${var.environment_name}"
  location                      = "East US"
  resource_group_name           = var.resource_group_name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = false
}
