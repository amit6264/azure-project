resource "azurerm_public_ip" "this" {

  name                = "${var.name}-pip"

  location            = var.location

  resource_group_name = var.resource_group_name

  allocation_method = "Static"

  sku = "Standard"

  zones = ["1", "2", "3"]

  tags = var.tags
}



resource "azurerm_firewall_policy" "this" {

  name                = "${var.name}-policy"

  location            = var.location

  resource_group_name = var.resource_group_name

  sku = "Premium"

  intrusion_detection {

    mode = "Alert"
  }

  threat_intelligence_mode = "Alert"

  tags = var.tags
}




resource "azurerm_firewall" "this" {

  name                = var.name

  location            = var.location

  resource_group_name = var.resource_group_name

  sku_name = "AZFW_VNet"

  sku_tier = "Premium"

  firewall_policy_id =
  azurerm_firewall_policy.this.id

  ip_configuration {

    name = "fw-config"

    subnet_id =
    var.firewall_subnet_id

    public_ip_address_id =
    azurerm_public_ip.this.id
  }

  tags = var.tags
}




resource "azurerm_firewall_policy_rule_collection_group" "aks" {

  name = "aks-egress"

  firewall_policy_id =
  azurerm_firewall_policy.this.id

  priority = 100

  network_rule_collection {

    name = "aks-required"

    priority = 100

    action = "Allow"

    rule {

      name = "https"

      protocols = ["TCP"]

      source_addresses = ["10.0.0.0/8"]

      destination_ports = ["443"]

      destination_addresses = ["*"]
    }
  }
}






resource "azurerm_firewall_policy_rule_collection_group" "dns" {

  name = "dns-rules"

  firewall_policy_id =
  azurerm_firewall_policy.this.id

  priority = 200

  network_rule_collection {

    name = "dns"

    priority = 100

    action = "Allow"

    rule {

      name = "dns"

      protocols = ["UDP"]

      source_addresses = ["10.0.0.0/8"]

      destination_ports = ["53"]

      destination_addresses = ["*"]
    }
  }
}
