resource_group_name = "rg-cmic-1"
location            = "Southeast Asia"
vnet_name           = "vnet-dify"
environment         = "dev"

vnet_address_space = "10.0.0.0/16"

container_images = {
  nginx         = "nginx:mainline-alpine3.22"
  api           = "langgenius/dify-api:1.5.0"
  web           = "langgenius/dify-web:1.5.0"
  sandbox       = "langgenius/dify-sandbox:0.2.12"
  weaviate      = "semitechnologies/weaviate:1.19.0"
  ssrf_proxy    = "ubuntu/squid:6.10-24.10_edge"
  plugin_daemon = "langgenius/dify-plugin-daemon:0.1.2-local"
  worker        = "langgenius/dify-api:1.5.0"
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
    cpu    = 0.5
    memory = "1Gi"
  }
  worker = {
    cpu    = 0.5
    memory = "1Gi"
  }
  sandbox = {
    cpu    = 0.25
    memory = "0.5Gi"
  }
  ssrf_proxy = {
    cpu    = 0.25
    memory = "0.5Gi"
  }
  weaviate = {
    cpu    = 0.5
    memory = "1Gi"
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

storage_allowed_ip_rules = ["210.245.54.242"]
