resource "azurerm_log_analytics_workspace" "this" {

  name                = var.log_analytics_name

  location            = var.location

  resource_group_name = var.resource_group_name

  sku = "PerGB2018"

  retention_in_days = 30

  internet_ingestion_enabled = true

  internet_query_enabled = true

  tags = var.tags
}




resource "azurerm_monitor_workspace" "this" {

  name                = var.monitor_workspace_name

  location            = var.location

  resource_group_name = var.resource_group_name

  tags = var.tags
}



resource "azurerm_dashboard_grafana" "this" {

  name                = var.grafana_name

  location            = var.location

  resource_group_name = var.resource_group_name

  api_key_enabled = true

  deterministic_outbound_ip_enabled = true

  public_network_access_enabled = false

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}





resource "azurerm_role_assignment" "grafana_monitor" {

  scope =
  azurerm_monitor_workspace.this.id

  role_definition_name =
  "Monitoring Reader"

  principal_id =
  azurerm_dashboard_grafana.this.identity[0].principal_id
}





resource "azurerm_role_assignment" "grafana_logs" {

  scope =
  azurerm_log_analytics_workspace.this.id

  role_definition_name =
  "Log Analytics Reader"

  principal_id =
  azurerm_dashboard_grafana.this.identity[0].principal_id
}




resource "azurerm_private_endpoint" "law" {

  name = "law-private-endpoint"

  location = var.location

  resource_group_name =
  var.resource_group_name

  subnet_id =
  var.private_endpoint_subnet_id

  private_service_connection {

    name = "law-connection"

    private_connection_resource_id =
    azurerm_log_analytics_workspace.this.id

    subresource_names = [
      "azuremonitor"
    ]

    is_manual_connection = false
  }
}




resource "azurerm_private_dns_zone_group" "monitor" {

  name = "monitor-dns"

  private_endpoint_id =
  azurerm_private_endpoint.law.id

  private_dns_zone_configs {

    name = "monitor-zone"

    private_dns_zone_id =
    var.monitor_private_dns_zone_id
  }
}



resource "azurerm_application_insights" "this" {

  name = "appi-platform"

  location = var.location

  resource_group_name =
  var.resource_group_name

  workspace_id =
  azurerm_log_analytics_workspace.this.id

  application_type = "web"

  tags = var.tags
}
