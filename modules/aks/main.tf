resource "azurerm_kubernetes_cluster" "this" {

  name                = var.cluster_name

  location            = var.location

  resource_group_name = var.resource_group_name

  dns_prefix = replace(var.cluster_name, "-", "")

  kubernetes_version = var.kubernetes_version

  private_cluster_enabled = true

  private_cluster_public_fqdn_enabled = false

  role_based_access_control_enabled = true

  oidc_issuer_enabled = true

  workload_identity_enabled = true

  image_cleaner_enabled = true

  image_cleaner_interval_hours = 48

  sku_tier = "Standard"

  automatic_upgrade_channel = "stable"

  node_os_upgrade_channel = "NodeImage"

  azure_policy_enabled = true

  local_account_disabled = true

  default_node_pool {

    name = "system"

    vm_size = "Standard_D4ds_v5"

    node_count = 3

    min_count = 3

    max_count = 10

    auto_scaling_enabled = true

    orchestrator_version = var.kubernetes_version

    availability_zones = ["1","2","3"]

    vnet_subnet_id = var.subnet_id

    only_critical_addons_enabled = true

    os_disk_size_gb = 128

    type = "VirtualMachineScaleSets"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {

    network_plugin = "azure"

    network_plugin_mode = "overlay"

    network_policy = "azure"

    outbound_type = "userDefinedRouting"

    service_cidr = "172.16.0.0/16"

    dns_service_ip = "172.16.0.10"

    pod_cidr = "192.168.0.0/16"
  }

  oms_agent {

    log_analytics_workspace_id =
    var.log_analytics_workspace_id
  }

  monitor_metrics {}
  
  tags = var.tags
}







resource "azurerm_kubernetes_cluster_node_pool" "user" {

  name = "user"

  kubernetes_cluster_id =
  azurerm_kubernetes_cluster.this.id

  vm_size = "Standard_D8ds_v5"

  mode = "User"

  enable_auto_scaling = true

  min_count = 2

  max_count = 20

  node_taints = []

  orchestrator_version =
  azurerm_kubernetes_cluster.this.kubernetes_version

  availability_zones = ["1","2","3"]

  vnet_subnet_id = var.subnet_id

  os_disk_size_gb = 128
}






resource "azurerm_kubernetes_cluster_node_pool" "spot" {

  name = "spot"

  kubernetes_cluster_id =
  azurerm_kubernetes_cluster.this.id

  vm_size = "Standard_D4ds_v5"

  mode = "User"

  priority = "Spot"

  eviction_policy = "Delete"

  spot_max_price = -1

  enable_auto_scaling = true

  min_count = 0

  max_count = 10

  availability_zones = ["1","2","3"]

  vnet_subnet_id = var.subnet_id
}





resource "azurerm_role_assignment" "acr_pull" {

  principal_id =
  azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id

  role_definition_name = "AcrPull"

  scope = var.acr_id
}
