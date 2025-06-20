terraform plan -var="env=stg"
terraform apply -var="env=stg"
terraform destroy -var="env=stg"
az account show --output table

terraform apply -target=module.network.azurerm_nat_gateway.nat

terraform apply -target=module.network.azurerm_public_ip.nat_ip -target=module.network.azurerm_nat_gateway.nat -var="env=stg"