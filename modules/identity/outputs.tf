output "aks_identity_id" {
  value = azurerm_user_assigned_identity.aks.id
}

output "aks_principal_id" {
  value = azurerm_user_assigned_identity.aks.principal_id
}

output "github_identity_id" {
  value = azurerm_user_assigned_identity.github.id
}

output "github_client_id" {
  value = azurerm_user_assigned_identity.github.client_id
}

output "github_principal_id" {
  value = azurerm_user_assigned_identity.github.principal_id
}

output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}

output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}
