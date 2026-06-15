resource "azurerm_storage_account" "this" {

  name = var.name

  resource_group_name =
  var.resource_group_name

  location = var.location

  account_tier = "Standard"

  account_replication_type = "GZRS"

  account_kind = "StorageV2"

  min_tls_version = "TLS1_2"

  public_network_access_enabled = false

  shared_access_key_enabled = false

  allow_nested_items_to_be_public = false

  infrastructure_encryption_enabled = true

  tags = var.tags
}




resource "azurerm_storage_container" "app" {

  name = "application-data"

  storage_account_name =
  azurerm_storage_account.this.name

  container_access_type = "private"
}



resource "azurerm_storage_container" "logs" {

  name = "logs"

  storage_account_name =
  azurerm_storage_account.this.name

  container_access_type = "private"
}



resource "azurerm_storage_container" "backup" {

  name = "backup"

  storage_account_name =
  azurerm_storage_account.this.name

  container_access_type = "private"
}





resource "azurerm_storage_management_policy" "this" {

  storage_account_id =
  azurerm_storage_account.this.id

  rule {

    name    = "archive-old-blobs"
    enabled = true

    filters {

      blob_types = ["blockBlob"]
    }

    actions {

      base_blob {

        tier_to_cool_after_days_since_modification_greater_than = 30

        tier_to_archive_after_days_since_modification_greater_than = 90

        delete_after_days_since_modification_greater_than = 365
      }
    }
  }
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
    azurerm_storage_account.this.id

    subresource_names = [
      "blob"
    ]

    is_manual_connection = false
  }
}



resource "azurerm_private_dns_zone_group" "this" {

  name = "storage-dns"

  private_endpoint_id =
  azurerm_private_endpoint.this.id

  private_dns_zone_configs {

    name = "blob-zone"

    private_dns_zone_id =
    var.storage_dns_zone_id
  }
}
