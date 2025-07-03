variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_id" {
  description = "ID of existing VNet"
  type        = string
}

variable "vnet_name" {
  description = "Name of existing VNet"
  type        = string
}

variable "vnet_address_space" {
  description = "Address space of existing VNet"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}
