resource "azurerm_recovery_services_vault" "this" {

  name                = var.name

  location            = var.location

  resource_group_name = var.resource_group_name

  sku = "Standard"

  storage_mode_type = "GeoRedundant"

  cross_region_restore_enabled = true

  soft_delete_enabled = true

  tags = var.tags
}


resource "azurerm_data_protection_backup_vault" "this" {

  name = "${var.name}-dp"

  resource_group_name =
  var.resource_group_name

  location = var.location

  datastore_type = "VaultStore"

  redundancy = "GeoRedundant"

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}




resource "azurerm_data_protection_backup_policy_blob_storage" "this" {

  name = "blob-backup-policy"

  vault_id =
  azurerm_data_protection_backup_vault.this.id

  operational_default_retention_duration = "P30D"
}




resource "azurerm_data_protection_backup_instance_blob_storage" "this" {

  name = "storage-backup"

  location = var.location

  vault_id =
  azurerm_data_protection_backup_vault.this.id

  storage_account_id =
  var.storage_account_id

  backup_policy_id =
  azurerm_data_protection_backup_policy_blob_storage.this.id
}



resource "azurerm_monitor_diagnostic_setting" "backup" {

  name = "backup-diagnostics"

  target_resource_id =
  azurerm_recovery_services_vault.this.id

  log_analytics_workspace_id =
  data.azurerm_log_analytics_workspace.this.id

  enabled_log {
    category = "AzureBackupReport"
  }

  metric {
    category = "AllMetrics"
  }
}




data "azurerm_log_analytics_workspace" "this" {

  name = "law-prod"

  resource_group_name =
  var.resource_group_name
}
