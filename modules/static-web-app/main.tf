resource "azurerm_static_web_app" "this" {

  name                = var.name

  resource_group_name = var.resource_group_name

  location            = var.location

  sku_tier = var.sku_tier

  sku_size = var.sku_size

  tags = var.tags
}




resource "azapi_update_resource" "identity" {

  type = "Microsoft.Web/staticSites@2023-01-01"

  resource_id =
  azurerm_static_web_app.this.id

  body = jsonencode({
    identity = {
      type = "SystemAssigned"
    }
  })
}
