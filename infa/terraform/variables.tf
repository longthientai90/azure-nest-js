variable "env" {
  description = "Deployment environment: dev, stg, demo, or prod"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "stg", "demo", "prod"], var.env)
    error_message = "Environment must be dev, stg, demo, or prod."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "eastus"
}

variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = ""
}
