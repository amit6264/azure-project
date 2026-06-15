resource "azurerm_role_assignment" "github_contributor" {

  scope =
  "/subscriptions/${var.subscription_id}"

  role_definition_name = "Contributor"

  principal_id =
  var.github_principal_id
}


resource "azurerm_role_assignment" "github_uaa" {

  scope =
  "/subscriptions/${var.subscription_id}"

  role_definition_name =
  "User Access Administrator"

  principal_id =
  var.github_principal_id
}



resource "azurerm_role_assignment" "acr_pull" {

  scope = var.acr_id

  role_definition_name = "AcrPull"

  principal_id =
  var.aks_principal_id
}



resource "azurerm_role_assignment" "keyvault_secrets" {

  scope = var.keyvault_id

  role_definition_name =
  "Key Vault Secrets User"

  principal_id =
  var.aks_principal_id
}



resource "azurerm_role_assignment" "storage_blob" {

  count =
  var.storage_account_id != null ? 1 : 0

  scope = var.storage_account_id

  role_definition_name =
  "Storage Blob Data Contributor"

  principal_id =
  var.aks_principal_id
}



resource "azurerm_role_assignment" "cosmos_reader" {

  count =
  var.cosmosdb_id != null ? 1 : 0

  scope = var.cosmosdb_id

  role_definition_name =
  "Cosmos DB Account Reader Role"

  principal_id =
  var.aks_principal_id
}
