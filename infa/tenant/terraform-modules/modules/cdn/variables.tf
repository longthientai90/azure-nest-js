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

variable "origin_url" {
  description = "Origin URL for CDN (web app URL)"
  type        = string
}

variable "storage_account_name" {
  description = "Storage account name for static assets"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
