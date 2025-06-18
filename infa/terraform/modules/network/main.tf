locals {
  nat_gateway_name = "nat-zenblog-${var.env}-${var.location}"
  nat_ip_name      = "pip-zenblog-${var.env}-${var.location}"
}

resource "azurerm_public_ip" "nat_ip" {
  name                = local.nat_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat" {
  name                = local.nat_gateway_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "nat_ip" {
  nat_gateway_id       = azurerm_nat_gateway.nat.id
  public_ip_address_id = azurerm_public_ip.nat_ip.id
}

resource "azurerm_subnet_nat_gateway_association" "private_nat" {
  subnet_id      = var.private_subnet_id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}
