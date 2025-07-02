resource_group_name      = "rg-cmic-1"
location                 = "Southeast Asia"
vnet_name                = "vnet-cmic"
vnet_resource_group_name = "rg-cmic"
environment              = "dev"

container_images = {
  nginx = "nginx:latest"
  api   = "nginx:latest"
  web   = "nginx:latest"
}

container_resources = {
  nginx = {
    cpu    = 0.25
    memory = "0.5Gi"
  }
  api = {
    cpu    = 0.5
    memory = "1Gi"
  }
  web = {
    cpu    = 0.25
    memory = "0.5Gi"
  }
}

scaling_config = {
  nginx = {
    min_replicas = 1
    max_replicas = 3
  }
  api = {
    min_replicas = 1
    max_replicas = 5
  }
  web = {
    min_replicas = 1
    max_replicas = 3
  }
}
