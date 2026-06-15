module "resource_groups" {

  source = "./modules/resource-group"

  for_each = var.regions

  name = "rg-${each.key}-${var.environment}"

  location = each.value.location

  tags = local.common_tags
}
