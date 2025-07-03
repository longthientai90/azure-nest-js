variable "environment" {
  description = "Môi trường triển khai (dev, staging, prod, ...)"
  type        = string
}

variable "resource_group_name" {
  description = "Tên resource group Azure"
  type        = string
}

variable "location" {
  description = "Vị trí Azure region"
  type        = string
}

variable "admin_username" {
  description = "Tên user quản trị PostgreSQL"
  type        = string
}

variable "admin_password" {
  description = "Mật khẩu user quản trị PostgreSQL"
  type        = string
  sensitive   = true
}

variable "private_endpoint_subnet_id" {
  description = "Subnet id cho Private Endpoint"
  type        = string
}

variable "private_dns_zone_id" {
  description = "ID của Private DNS Zone cho PostgreSQL Flexible Server"
  type        = string
}
