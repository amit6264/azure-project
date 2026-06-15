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
