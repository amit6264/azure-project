resource "azurerm_redis_enterprise_cluster" "this" {

  name                = var.name

  location            = var.location

  resource_group_name = var.resource_group_name

  sku_name = "Enterprise_E10"

  minimum_tls_version = "1.2"

  zones = ["1", "2", "3"]

  tags = var.tags
}




resource "azurerm_redis_enterprise_database" "this" {

  name = "default"

  cluster_id =
  azurerm_redis_enterprise_cluster.this.id

  client_protocol = "Encrypted"

  clustering_policy = "EnterpriseCluster"
}




resource "azurerm_private_endpoint" "this" {

  name = "${var.name}-pe"

  location = var.location

  resource_group_name =
  var.resource_group_name

  subnet_id =
  var.private_endpoint_subnet_id

  private_service_connection {

    name = "${var.name}-psc"

    private_connection_resource_id =
    azurerm_redis_enterprise_cluster.this.id

    subresource_names = [
      "redisEnterprise"
    ]

    is_manual_connection = false
  }

  tags = var.tags
}
