resource "azurerm_key_vault" "this" {

  name                = var.name

  location            = var.location

  resource_group_name = var.resource_group_name

  tenant_id           = var.tenant_id

  sku_name            = "premium"

  enable_rbac_authorization = true

  public_network_access_enabled = false

  purge_protection_enabled = true

  soft_delete_retention_days = 90

  tags = var.tags
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
    azurerm_key_vault.this.id

    subresource_names = [
      "vault"
    ]

    is_manual_connection = false
  }

  tags = var.tags
}




resource "azurerm_private_dns_zone_group" "this" {

  name = "kv-dns-zone-group"

  private_endpoint_id =
  azurerm_private_endpoint.this.id

  private_dns_zone_configs {

    name = "kv-zone"

    private_dns_zone_id =
    var.keyvault_private_dns_zone_id
  }
}
