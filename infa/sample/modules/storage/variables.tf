# Variables for storage module

# Variables
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for private endpoint"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "storage_allowed_ip_rules" {
  description = "List of allowed IP addresses for storage account"
  type        = list(string)
  default     = []
}
