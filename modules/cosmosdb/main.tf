resource "azurerm_cosmosdb_account" "this" {

  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  offer_type = "Standard"

  kind = "GlobalDocumentDB"

  automatic_failover_enabled = true

  public_network_access_enabled = false

  consistency_policy {

    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  geo_location {
    location          = "eastasia"
    failover_priority = 1
  }

  geo_location {
    location          = "uaenorth"
    failover_priority = 2
  }

  tags = var.tags
}





resource "azurerm_private_endpoint" "this" {

  name                = "${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name

  subnet_id = var.private_endpoint_subnet_id

  private_service_connection {

    name                           = "${var.name}-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.this.id

    subresource_names = ["Sql"]

    is_manual_connection = false
  }
}
