resource "azurerm_cdn_frontdoor_firewall_policy" "waf" {
  name                = var.waf_name
  resource_group_name = var.rg_name
  sku_name            = var.sku_name_waf
  enabled             = var.waf_enabled
  mode                = var.mode_waf

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_cdn_frontdoor_security_policy" "association" {
  name                     = "Security-Policy"
  cdn_frontdoor_profile_id = var.afd_id

  security_policies {
    firewall {
      cdn_frontdoor_firewall_policy_id = azurerm_cdn_frontdoor_firewall_policy.waf.id

      association {
        domain {
          cdn_frontdoor_domain_id = var.frontdoor_endpoint
        }
        patterns_to_match = ["/*"]
      }
    }
  }
}
