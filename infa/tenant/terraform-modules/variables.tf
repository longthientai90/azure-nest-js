variable "company_name" {
  description = "Full company name"
  type        = string
}

variable "company_slug" {
  description = "Company slug for resource naming"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.company_slug))
    error_message = "Company slug must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "azure_region" {
  description = "Azure region"
  type        = string
  default     = "Southeast Asia"
}

variable "vnet_cidr" {
  description = "CIDR block for VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for private subnet"
  type        = string
  default     = "10.0.2.0/24"
}

variable "db_admin_username" {
  description = "Database admin username"
  type        = string
  default     = "dbadmin"
}

variable "api_container_image" {
  description = "API container image"
  type        = string
}

variable "web_container_image" {
  description = "Web container image"
  type        = string
}
