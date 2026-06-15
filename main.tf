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
