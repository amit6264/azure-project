resource "azurerm_redis_enterprise_cluster" "this" {

  name                = var.name

  location            = var.location

  resource_group_name = var.resource_group_name

  sku_name = "Enterprise_E10"

  minimum_tls_version = "1.2"

  zones = ["1", "2", "3"]

  tags = var.tags
}
