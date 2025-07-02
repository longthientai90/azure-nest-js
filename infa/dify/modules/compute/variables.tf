# Variables for compute module

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "ID of the Log Analytics Workspace"
  type        = string
}

variable "container_app_subnet_id" {
  description = "Subnet ID for Container Apps"
  type        = string
}

variable "storage_connection_string" {
  description = "Storage connection string for API app"
  type        = string
  default     = ""
}
