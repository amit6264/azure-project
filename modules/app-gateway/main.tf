resource "azurerm_public_ip" "this" {

  name                = "${var.name}-pip"

  location            = var.location

  resource_group_name = var.resource_group_name

  allocation_method = "Static"

  sku = "Standard"

  zones = ["1", "2", "3"]

  tags = var.tags
}



resource "azurerm_web_application_firewall_policy" "this" {

  name = "${var.name}-waf"

  resource_group_name =
  var.resource_group_name

  location = var.location

  policy_settings {

    enabled = true

    mode = "Prevention"
  }

  managed_rules {

    managed_rule_set {

      type = "OWASP"

      version = "3.2"
    }
  }

  tags = var.tags
}




resource "azurerm_application_gateway" "this" {

  name                = var.name

  location            = var.location

  resource_group_name = var.resource_group_name

  firewall_policy_id =
  azurerm_web_application_firewall_policy.this.id

  sku {

    name = "WAF_v2"

    tier = "WAF_v2"

    capacity = 2
  }

  gateway_ip_configuration {

    name = "gateway-ip"

    subnet_id = var.subnet_id
  }

  frontend_ip_configuration {

    name = "frontend"

    public_ip_address_id =
    azurerm_public_ip.this.id
  }

  frontend_port {

    name = "https"

    port = 443
  }

  backend_address_pool {

    name = "default-backend"
  }

  backend_http_settings {

    name = "https-setting"

    cookie_based_affinity = "Disabled"

    port = 443

    protocol = "Https"

    request_timeout = 60
  }

  http_listener {

    name = "https-listener"

    frontend_ip_configuration_name = "frontend"

    frontend_port_name = "https"

    protocol = "Https"
  }

  request_routing_rule {

    name = "default-rule"

    rule_type = "Basic"

    http_listener_name = "https-listener"

    backend_address_pool_name = "default-backend"

    backend_http_settings_name = "https-setting"

    priority = 100
  }

  autoscale_configuration {

    min_capacity = 2

    max_capacity = 10
  }

  tags = var.tags
}
