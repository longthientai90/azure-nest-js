# Variables for compute module

variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "environment_name" { type = string }
variable "log_analytics_workspace_id" { type = string }
variable "subnet_id" { type = string }
variable "api_image" { type = string }
variable "web_image" { type = string }
variable "nginx_image" { type = string }
variable "postgres_host" {
  type    = string
  default = ""
}
variable "redis_host" {
  type    = string
  default = ""
}
variable "openai_endpoint" {
  type    = string
  default = ""
}
