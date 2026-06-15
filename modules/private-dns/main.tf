resource "azurerm_private_dns_zone" "acr" {

  name = "privatelink.azurecr.io"

  resource_group_name = var.resource_group_name

  tags = var.tags
}


resource "azurerm_private_dns_zone" "kv" {

  name = "privatelink.vaultcore.azure.net"

  resource_group_name = var.resource_group_name

  tags = var.tags
}


resource "azurerm_private_dns_zone" "monitor" {

  name = "privatelink.monitor.azure.com"

  resource_group_name = var.resource_group_name

  tags = var.tags
}


resource "azurerm_private_dns_zone" "oms" {

  name = "privatelink.oms.opinsights.azure.com"

  resource_group_name = var.resource_group_name

  tags = var.tags
}


resource "azurerm_private_dns_zone_virtual_network_link" "acr_links" {

  for_each = var.vnet_ids

  name = "acr-${each.key}"

  resource_group_name =
  var.resource_group_name

  private_dns_zone_name =
  azurerm_private_dns_zone.acr.name

  virtual_network_id =
  each.value
}


resource "azurerm_private_dns_zone_virtual_network_link" "kv_links" {

  for_each = var.vnet_ids

  name = "kv-${each.key}"

  resource_group_name =
  var.resource_group_name

  private_dns_zone_name =
  azurerm_private_dns_zone.kv.name

  virtual_network_id =
  each.value
}


resource "azurerm_private_dns_zone_virtual_network_link" "monitor_links" {

  for_each = var.vnet_ids

  name = "monitor-${each.key}"

  resource_group_name =
  var.resource_group_name

  private_dns_zone_name =
  azurerm_private_dns_zone.monitor.name

  virtual_network_id =
  each.value
}



resource "azurerm_private_dns_zone_virtual_network_link" "oms_links" {

  for_each = var.vnet_ids

  name = "oms-${each.key}"

  resource_group_name =
  var.resource_group_name

  private_dns_zone_name =
  azurerm_private_dns_zone.oms.name

  virtual_network_id =
  each.value
}


resource "azurerm_private_dns_zone_virtual_network_link" "aks_links" {

  for_each = var.vnet_ids

  name = "aks-${each.key}"

  resource_group_name =
  var.resource_group_name

  private_dns_zone_name =
  azurerm_private_dns_zone.aks.name

  virtual_network_id =
  each.value
}




resource "azurerm_private_dns_zone" "mysql" {

  name =
  "privatelink.mysql.database.azure.com"

  resource_group_name =
  var.resource_group_name
}



resource "azurerm_private_dns_zone_virtual_network_link" "mysql" {

  for_each = var.vnet_ids

  name = "mysql-${each.key}"

  resource_group_name =
  var.resource_group_name

  private_dns_zone_name =
  azurerm_private_dns_zone.mysql.name

  virtual_network_id =
  each.value
}




resource "azurerm_private_dns_zone" "cosmos" {

  name = "privatelink.documents.azure.com"

  resource_group_name =
  var.resource_group_name

  tags = var.tags
}




resource "azurerm_private_dns_zone_virtual_network_link" "cosmos_links" {

  for_each = var.vnet_ids

  name = "cosmos-${each.key}"

  resource_group_name =
  var.resource_group_name

  private_dns_zone_name =
  azurerm_private_dns_zone.cosmos.name

  virtual_network_id =
  each.value
}




resource "azurerm_private_dns_zone" "storage_blob" {

  name = "privatelink.blob.core.windows.net"

  resource_group_name =
  var.resource_group_name

  tags = var.tags
}



resource "azurerm_private_dns_zone_virtual_network_link" "storage_blob_links" {

  for_each = var.vnet_ids

  name = "storage-${each.key}"

  resource_group_name =
  var.resource_group_name

  private_dns_zone_name =
  azurerm_private_dns_zone.storage_blob.name

  virtual_network_id =
  each.value
}
