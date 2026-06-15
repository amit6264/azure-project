resource "azurerm_mysql_flexible_server" "this" {

  name = var.name

  resource_group_name =
  var.resource_group_name

  location = var.location

  administrator_login =
  var.admin_username

  administrator_password =
  var.admin_password

  sku_name = "GP_Standard_D4ds_v5"

  version = "8.0.21"

  delegated_subnet_id =
  var.delegated_subnet_id

  private_dns_zone_id =
  var.private_dns_zone_id

  backup_retention_days = 35

  geo_redundant_backup_enabled = true

  zone = "1"

  storage {

    size_gb = 128

    auto_grow_enabled = true
  }

  high_availability {

    mode = "ZoneRedundant"
  }

  tags = var.tags

  depends_on = [
    azurerm_private_dns_zone_virtual_network_link.mysql
  ]
}

