variable "company_slug" {
  description = "Company slug for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for container apps"
  type        = string
}

variable "database_host" {
  description = "Database host"
  type        = string
}

variable "database_name" {
  description = "Database name"
  type        = string
}

variable "database_username" {
  description = "Database username"
  type        = string
}

variable "database_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}

variable "storage_account_name" {
  description = "Storage account name"
  type        = string
}

variable "storage_account_key" {
  description = "Storage account key"
  type        = string
  sensitive   = true
}

variable "ai_services_endpoint" {
  description = "AI Services endpoint"
  type        = string
}

variable "ai_services_key" {
  description = "AI Services key"
  type        = string
  sensitive   = true
}

variable "api_image" {
  description = "API container image"
  type        = string
}

variable "web_image" {
  description = "Web container image"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
