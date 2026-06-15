output "acr_dns_zone_id" {
  value = azurerm_private_dns_zone.acr.id
}

output "keyvault_dns_zone_id" {
  value = azurerm_private_dns_zone.kv.id
}

output "monitor_dns_zone_id" {
  value = azurerm_private_dns_zone.monitor.id
}

output "oms_dns_zone_id" {
  value = azurerm_private_dns_zone.oms.id
}

output "aks_dns_zone_id" {
  value = azurerm_private_dns_zone.aks.id
}
