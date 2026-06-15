resource "azurerm_security_center_subscription_pricing" "cspm" {

  tier          = "Standard"

  resource_type = "CloudPosture"
}


resource "azurerm_security_center_subscription_pricing" "containers" {

  count = var.enable_containers ? 1 : 0

  tier = "Standard"

  resource_type = "Containers"
}




resource "azurerm_security_center_subscription_pricing" "storage" {

  count = var.enable_storage ? 1 : 0

  tier = "Standard"

  resource_type = "StorageAccounts"
}




resource "azurerm_security_center_subscription_pricing" "keyvault" {

  count = var.enable_keyvault ? 1 : 0

  tier = "Standard"

  resource_type = "KeyVaults"
}



resource "azurerm_security_center_subscription_pricing" "cosmosdb" {

  count = var.enable_cosmosdb ? 1 : 0

  tier = "Standard"

  resource_type = "CosmosDbs"
}




resource "azurerm_security_center_subscription_pricing" "servers" {

  count = var.enable_servers ? 1 : 0

  tier = "Standard"

  resource_type = "VirtualMachines"
}




resource "azurerm_security_center_subscription_pricing" "arm" {

  tier = "Standard"

  resource_type = "Arm"
}




resource "azurerm_security_center_subscription_pricing" "dns" {

  tier = "Standard"

  resource_type = "Dns"
}



resource "azurerm_security_center_auto_provisioning" "this" {

  auto_provision = "On"
}
