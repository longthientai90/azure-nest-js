# Cognitive Services Account
resource "azurerm_cognitive_account" "main" {
  name                = "${var.company_slug}-${var.environment}-ai"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "CognitiveServices"
  sku_name            = "S0"

  tags = var.tags
}
