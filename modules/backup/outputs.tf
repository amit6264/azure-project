output "recovery_vault_id" {
  value = azurerm_recovery_services_vault.this.id
}

output "backup_vault_id" {
  value =
  azurerm_data_protection_backup_vault.this.id
}
