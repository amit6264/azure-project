resource "azurerm_container_registry" "this" {

  name                = var.name

  resource_group_name = var.resource_group_name

  location            = var.location

  sku = "Premium"

  admin_enabled = false

  public_network_access_enabled = false

  anonymous_pull_enabled = false

  tags = var.tags
}



resource "azurerm_container_registry_replication" "asia" {

  name = "eastasia"

  location = "eastasia"

  container_registry_id =
  azurerm_container_registry.this.id

  zone_redundancy_enabled = true

  regional_endpoint_enabled = true
}



resource "azurerm_container_registry_replication" "uae" {

  name = "uaenorth"

  location = "uaenorth"

  container_registry_id =
  azurerm_container_registry.this.id

  zone_redundancy_enabled = true

  regional_endpoint_enabled = true
}




resource "azurerm_private_endpoint" "this" {

  name = "${var.name}-pe"

  location = var.location

  resource_group_name =
  var.resource_group_name

  subnet_id =
  var.private_endpoint_subnet_id

  private_service_connection {

    name = "${var.name}-psc"

    private_connection_resource_id =
    azurerm_container_registry.this.id

    subresource_names = [
      "registry"
    ]

    is_manual_connection = false
  }
}





resource "azurerm_private_dns_zone_group" "this" {

  name = "acr-dns"

  private_endpoint_id =
  azurerm_private_endpoint.this.id

  private_dns_zone_configs {

    name = "acr-zone"

    private_dns_zone_id =
    var.acr_private_dns_zone_id
  }
}
