# OpenAI module

variable "resource_group_name" { type = string }
variable "environment_name" { type = string }

resource "azurerm_cognitive_account" "openai" {
  name                          = "openai-${var.environment_name}"
  location                      = "East US"
  resource_group_name           = var.resource_group_name
  kind                          = "OpenAI"
  sku_name                      = "S0"
  public_network_access_enabled = false
}

output "openai_endpoint" {
  value = azurerm_cognitive_account.openai.endpoint
}
output "openai_id" {
  value = azurerm_cognitive_account.openai.id
}
output "primary_access_key" {
  value     = azurerm_cognitive_account.openai.primary_access_key
  sensitive = true
}
