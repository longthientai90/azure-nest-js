variable "env" {
  description = "Deployment environment: dev, stg, demo, or prod"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "private_subnet_id" {
  description = "ID of the private subnet"
  type        = string
}
