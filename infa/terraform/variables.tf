variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-zenblog-stg"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "vnet-zenblog-stg"
}
