resource "azurerm_user_assigned_identity" "aks" {

  name = "id-aks-${var.environment}"

  location = var.location

  resource_group_name =
  var.resource_group_name

  tags = var.tags
}


resource "azurerm_user_assigned_identity" "github" {

  name = "id-github-${var.environment}"

  location = var.location

  resource_group_name =
  var.resource_group_name

  tags = var.tags
}

data "azurerm_client_config" "current" {}



resource "azurerm_federated_identity_credential" "github_main" {

  name = "github-main"

  resource_group_name =
  var.resource_group_name

  parent_id =
  azurerm_user_assigned_identity.github.id

  audience = [
    "api://AzureADTokenExchange"
  ]

  issuer =
  "https://token.actions.githubusercontent.com"

  subject =
  "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/main"
}



resource "azurerm_federated_identity_credential" "github_pr" {

  name = "github-pr"

  resource_group_name =
  var.resource_group_name

  parent_id =
  azurerm_user_assigned_identity.github.id

  audience = [
    "api://AzureADTokenExchange"
  ]

  issuer =
  "https://token.actions.githubusercontent.com"

  subject =
  "repo:${var.github_org}/${var.github_repo}:pull_request"
}
