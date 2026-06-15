resource "azurerm_cdn_frontdoor_profile" "this" {

  name                = var.name

  resource_group_name = var.resource_group_name

  sku_name = "Premium_AzureFrontDoor"

  tags = var.tags
}


resource "azurerm_cdn_frontdoor_endpoint" "this" {

  name = "${var.name}-endpoint"

  cdn_frontdoor_profile_id =
  azurerm_cdn_frontdoor_profile.this.id
}



resource "azurerm_cdn_frontdoor_origin_group" "this" {

  name = "global-origin-group"

  cdn_frontdoor_profile_id =
  azurerm_cdn_frontdoor_profile.this.id

  load_balancing {

    sample_size = 4

    successful_samples_required = 3
  }

  health_probe {

    interval_in_seconds = 30

    path = "/health"

    protocol = "Https"

    request_type = "GET"
  }
}





resource "azurerm_cdn_frontdoor_origin" "eu" {

  name = "eu-origin"

  cdn_frontdoor_origin_group_id =
  azurerm_cdn_frontdoor_origin_group.this.id

  host_name =
  var.app_gateways["eu"].hostname

  http_port = 80

  https_port = 443

  origin_host_header =
  var.app_gateways["eu"].hostname

  priority = 1

  weight = 1000

  certificate_name_check_enabled = true
}




resource "azurerm_cdn_frontdoor_origin" "asia" {

  name = "asia-origin"

  cdn_frontdoor_origin_group_id =
  azurerm_cdn_frontdoor_origin_group.this.id

  host_name =
  var.app_gateways["asia"].hostname

  http_port = 80

  https_port = 443

  origin_host_header =
  var.app_gateways["asia"].hostname

  priority = 1

  weight = 1000

  certificate_name_check_enabled = true
}





resource "azurerm_cdn_frontdoor_origin" "uae" {

  name = "uae-origin"

  cdn_frontdoor_origin_group_id =
  azurerm_cdn_frontdoor_origin_group.this.id

  host_name =
  var.app_gateways["me"].hostname

  http_port = 80

  https_port = 443

  origin_host_header =
  var.app_gateways["me"].hostname

  priority = 1

  weight = 1000

  certificate_name_check_enabled = true
}




resource "azurerm_cdn_frontdoor_route" "this" {

  name = "default-route"

  cdn_frontdoor_endpoint_id =
  azurerm_cdn_frontdoor_endpoint.this.id

  cdn_frontdoor_origin_group_id =
  azurerm_cdn_frontdoor_origin_group.this.id

  cdn_frontdoor_origin_ids = [

    azurerm_cdn_frontdoor_origin.eu.id,
    azurerm_cdn_frontdoor_origin.asia.id,
    azurerm_cdn_frontdoor_origin.uae.id
  ]

  supported_protocols = [
    "Http",
    "Https"
  ]

  patterns_to_match = [
    "/*"
  ]

  forwarding_protocol =
  "HttpsOnly"

  https_redirect_enabled = true

  link_to_default_domain = true
}





resource "azurerm_cdn_frontdoor_firewall_policy" "this" {

  name = "${var.name}-waf"

  resource_group_name =
  var.resource_group_name

  sku_name = "Premium_AzureFrontDoor"

  enabled = true

  mode = "Prevention"

  managed_rule {

    type = "DefaultRuleSet"

    version = "2.1"

    action = "Block"
  }
}





resource "azurerm_cdn_frontdoor_security_policy" "this" {

  name = "global-security-policy"

  cdn_frontdoor_profile_id =
  azurerm_cdn_frontdoor_profile.this.id

  security_policies {

    firewall {

      cdn_frontdoor_firewall_policy_id =
      azurerm_cdn_frontdoor_firewall_policy.this.id

      association {

        domains {

          cdn_frontdoor_domain_id =
          azurerm_cdn_frontdoor_endpoint.this.id
        }

        patterns_to_match = ["/*"]
      }
    }
  }
}
