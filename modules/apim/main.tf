resource "azurerm_api_management" "this" {

  name                = var.name

  location            = var.location

  resource_group_name = var.resource_group_name

  publisher_name  = var.publisher_name

  publisher_email = var.publisher_email

  sku_name = "Premium_1"

  virtual_network_type = var.virtual_network_type

  virtual_network_configuration {

    subnet_id = var.appgw_subnet_id
  }

  public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}



resource "azurerm_api_management_additional_location" "asia" {

  api_management_id =
  azurerm_api_management.this.id

  location = "eastasia"

  virtual_network_configuration {

    subnet_id = var.appgw_subnet_id
  }
}




resource "azurerm_api_management_additional_location" "uae" {

  api_management_id =
  azurerm_api_management.this.id

  location = "uaenorth"

  virtual_network_configuration {

    subnet_id = var.appgw_subnet_id
  }
}




resource "azurerm_api_management_logger" "appinsights" {

  name = "applicationinsights"

  api_management_name =
  azurerm_api_management.this.name

  resource_group_name =
  var.resource_group_name

  application_insights {

    instrumentation_key =
    var.instrumentation_key
  }
}
