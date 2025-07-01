variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "rg-containerapp-learning"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "Southeast Asia" # Gần Việt Nam, chi phí thấp
}

variable "environment_name" {
  description = "Environment name"
  type        = string
  default     = "learning"
}
