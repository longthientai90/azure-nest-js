variable "container_images" {
  description = "Container images for the apps"
  type = object({
    nginx = string
    api   = string
    web   = string
  })
}

variable "container_resources" {
  description = "Container resource allocation"
  type = object({
    nginx = object({
      cpu    = number
      memory = string
    })
    api = object({
      cpu    = number
      memory = string
    })
    web = object({
      cpu    = number
      memory = string
    })
  })
}

variable "scaling_config" {
  description = "Scaling configuration for container apps"
  type = object({
    nginx = object({
      min_replicas = number
      max_replicas = number
    })
    api = object({
      min_replicas = number
      max_replicas = number
    })
    web = object({
      min_replicas = number
      max_replicas = number
    })
  })
}

variable "storage_allowed_ip_rules" {
  description = "List of IPs allowed to access storage account (for firewall rules)"
  type        = list(string)
  default     = []
}

variable "db_admin_password" {
  description = "Mật khẩu admin cho PostgreSQL"
  type        = string
  sensitive   = true
  default     = "Abc@12345"
}

variable "vnet_address_space" {
  description = "Address space for the VNet (CIDR block)"
  type        = string
}
