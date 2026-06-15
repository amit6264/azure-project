module "resource_groups" {

  source = "./modules/resource-group"

  for_each = var.regions

  name = "rg-${each.key}-${var.environment}"

  location = each.value.location

  tags = local.common_tags
}


module "network" {

  source = "./modules/network"

  for_each = var.regions

  resource_group_name =
  module.resource_groups[each.key].name

  location = each.value.location

  vnet_name = "vnet-${each.key}-${var.environment}"

  vnet_cidr = each.value.vnet_cidr

  aks_subnet_cidr =
  each.value.aks_subnet_cidr

  pe_subnet_cidr =
  each.value.pe_subnet_cidr

  firewall_subnet_cidr =
  each.value.firewall_subnet_cidr

  appgw_subnet_cidr =
  each.value.appgw_subnet_cidr

  tags = local.common_tags
}



module "shared_rg" {

  source = "./modules/resource-group"

  name = "rg-shared-prod"

  location = "westeurope"

  tags = local.common_tags
}




module "private_dns" {

  source = "./modules/private-dns"

  resource_group_name =
  module.shared_rg.name

  vnet_ids = {

    for k, v in module.network :

    k => v.vnet_id
  }

  tags = local.common_tags
}




module "identity" {

  source = "./modules/identity"

  resource_group_name =
  module.shared_rg.name

  location = "westeurope"

  environment = var.environment

  github_org = var.github_org

  github_repo = var.github_repo

  tags = local.common_tags
}




module "rbac" {

  source = "./modules/rbac"

  subscription_id =
  module.identity.subscription_id

  aks_principal_id =
  module.identity.aks_principal_id

  github_principal_id =
  module.identity.github_principal_id

  acr_id =
  module.acr.id

  keyvault_id =
  module.keyvault.id

  storage_account_id =
  module.storage.id

  cosmosdb_id =
  module.cosmosdb.id
}




module "acr" {

  source = "./modules/acr"

  name = "acrprod001"

  resource_group_name =
  module.shared_rg.name

  location = "westeurope"

  private_endpoint_subnet_id =
  module.network["eu"].private_endpoint_subnet_id

  acr_private_dns_zone_id =
  module.private_dns.acr_dns_zone_id

  tags = local.common_tags
}




module "keyvault" {

  source = "./modules/keyvault"

  name = "kv-prod-platform"

  location = "westeurope"

  resource_group_name =
  module.shared_rg.name

  tenant_id =
  module.identity.tenant_id

  private_endpoint_subnet_id =
  module.network["eu"].private_endpoint_subnet_id

  keyvault_private_dns_zone_id =
  module.private_dns.keyvault_dns_zone_id

  tags = local.common_tags
}





module "monitoring" {

  source = "./modules/monitoring"

  resource_group_name =
  module.shared_rg.name

  location = "westeurope"

  log_analytics_name =
  "law-prod"

  monitor_workspace_name =
  "amw-prod"

  grafana_name =
  "grafana-prod"

  private_endpoint_subnet_id =
  module.network["eu"].private_endpoint_subnet_id

  monitor_private_dns_zone_id =
  module.private_dns.monitor_dns_zone_id

  tags = local.common_tags
}





module "apim" {

  source = "./modules/apim"

  name = "apim-prod-global"

  resource_group_name =
  module.shared_rg.name

  location = "westeurope"

  publisher_name =
  "Platform Team"

  publisher_email =
  "platform@company.com"

  appgw_subnet_id =
  module.network["eu"].appgw_subnet_id

  instrumentation_key =
  module.monitoring.application_insights_connection_string

  tags = local.common_tags
}




module "static_web_app" {

  source = "./modules/static-web-app"

  name = "swa-prod-platform"

  resource_group_name =
  module.shared_rg.name

  location = "westeurope"

  tags = local.common_tags
}





module "mysql" {

  source = "./modules/mysql"

  for_each = var.regions

  name = "mysql-${each.key}-prod"

  resource_group_name =
  module.resource_groups[each.key].name

  location =
  each.value.location

  delegated_subnet_id =
  module.network[each.key].mysql_subnet_id

  private_dns_zone_id =
  module.private_dns.mysql_dns_zone_id

  admin_username =
  var.mysql_admin_username

  admin_password =
  var.mysql_admin_password

  tags = local.common_tags
}



module "cosmosdb" {

  source = "./modules/cosmosdb"

  name = "cosmos-prod"

  resource_group_name =
  module.shared_rg.name

  location = "westeurope"

  private_endpoint_subnet_id =
  module.network["eu"].private_endpoint_subnet_id

  cosmos_dns_zone_id =
  module.private_dns.cosmos_dns_zone_id

  tags = local.common_tags
}




module "redis" {

  source = "./modules/redis"

  for_each = var.regions

  name = "redis-${each.key}-prod"

  resource_group_name =
  module.resource_groups[each.key].name

  location =
  each.value.location

  private_endpoint_subnet_id =
  module.network[each.key].private_endpoint_subnet_id

  tags = local.common_tags
}





module "storage" {

  source = "./modules/storage"

  name = "stprodplatform001"

  resource_group_name =
  module.shared_rg.name

  location = "westeurope"

  private_endpoint_subnet_id =
  module.network["eu"].private_endpoint_subnet_id

  storage_dns_zone_id =
  module.private_dns.storage_blob_dns_zone_id

  tags = local.common_tags
}




module "firewall" {

  source = "./modules/firewall"

  for_each = var.regions

  name = "afw-${each.key}-prod"

  resource_group_name =
  module.resource_groups[each.key].name

  location =
  each.value.location

  firewall_subnet_id =
  module.network[each.key].firewall_subnet_id

  tags = local.common_tags
}






module "app_gateway" {

  source = "./modules/app-gateway"

  for_each = var.regions

  name = "agw-${each.key}-prod"

  resource_group_name =
  module.resource_groups[each.key].name

  location =
  each.value.location

  subnet_id =
  module.network[each.key].appgw_subnet_id

  tags = local.common_tags
}




module "frontdoor" {

  source = "./modules/frontdoor"

  name = "fd-global-prod"

  resource_group_name =
  module.shared_rg.name

  app_gateways = {

    eu = {
      hostname =
      module.app_gateway["eu"].public_ip
    }

    asia = {
      hostname =
      module.app_gateway["asia"].public_ip
    }

    me = {
      hostname =
      module.app_gateway["me"].public_ip
    }
  }

  tags = local.common_tags
}




module "defender" {

  source = "./modules/defender"

  subscription_id = data.azurerm_client_config.current.subscription_id

  enable_containers = true

  enable_storage = true

  enable_keyvault = true

  enable_cosmosdb = true

  enable_servers = true
}


data "azurerm_client_config" "current" {}




module "backup" {

  source = "./modules/backup"

  name = "rsv-prod"

  resource_group_name =
  module.shared_rg.name

  location = "westeurope"

  storage_account_id =
  module.storage.id

  tags = local.common_tags
}





module "aks" {

  source = "./modules/aks"

  for_each = var.regions

  cluster_name =
  "aks-${each.key}-prod"

  location =
  each.value.location

  resource_group_name =
  module.resource_groups[each.key].name

  subnet_id =
  module.network[each.key].aks_subnet_id

  acr_id =
  module.acr.id

  log_analytics_workspace_id =
  module.monitoring.log_analytics_workspace_id

  grafana_id =
  module.monitoring.grafana_id

  tags = local.common_tags
}
