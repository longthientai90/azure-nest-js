terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

locals {
  resource_group_name = var.resource_group_name != "" ? var.resource_group_name : "rg-zenblog-${var.env}-${var.location}"
  vnet_name           = var.vnet_name != "" ? var.vnet_name : "vnet-zenblog-${var.env}-${var.location}"
}

resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "private" {
  name                 = "sb-private"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "public" {
  name                 = "sb-public"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

module "network" {
  source              = "./modules/network"
  env                 = var.env
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  private_subnet_id   = azurerm_subnet.private.id
}
