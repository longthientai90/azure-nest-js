# Calculate subnet addresses dynamically
locals {
  # Parse the VNet CIDR to get base network
  vnet_cidr = var.vnet_address_space

  # Calculate subnet CIDRs based on VNet address space
  # Assuming VNet is /16, we'll use /24 subnets
  base_octets  = split(".", split("/", local.vnet_cidr)[0])
  base_network = "${local.base_octets[0]}.${local.base_octets[1]}"

  container_app_subnet_cidr    = "${local.base_network}.10.0/23"
  private_endpoint_subnet_cidr = "${local.base_network}.12.0/23"
}

# Subnet for Container Apps
resource "azurerm_subnet" "container_app" {
  name                 = "snet-containerapp-${var.environment}"
  resource_group_name  = split("/", var.vnet_id)[4] # Extract RG from VNet ID
  virtual_network_name = var.vnet_name
  address_prefixes     = [local.container_app_subnet_cidr]

  delegation {
    name = "Microsoft.App.environments"
    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

# Subnet for Private Endpoints
resource "azurerm_subnet" "private_endpoint" {
  name                 = "snet-pe-${var.environment}"
  resource_group_name  = split("/", var.vnet_id)[4]
  virtual_network_name = var.vnet_name
  address_prefixes     = [local.private_endpoint_subnet_cidr]
}

# Network Security Group for Container App subnet
resource "azurerm_network_security_group" "container_app" {
  name                = "nsg-containerapp-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# Network Security Group for Private Endpoint subnet
resource "azurerm_network_security_group" "private_endpoint" {
  name                = "nsg-pe-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowVNetInbound"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
  }
}

# Associate NSG with Container App subnet
resource "azurerm_subnet_network_security_group_association" "container_app" {
  subnet_id                 = azurerm_subnet.container_app.id
  network_security_group_id = azurerm_network_security_group.container_app.id
}

# Associate NSG with Private Endpoint subnet
resource "azurerm_subnet_network_security_group_association" "private_endpoint" {
  subnet_id                 = azurerm_subnet.private_endpoint.id
  network_security_group_id = azurerm_network_security_group.private_endpoint.id
}

# Đã tách biến và outputs sang file variables.tf và outputs.tf, chỉ giữ lại resource và local trong main.tf
