resource "azurerm_servicebus_namespace" "sbns" {
  name                          = var.servicebus_name
  location                      = var.location
  resource_group_name           = var.rg_name
  sku                           = var.sku_sbns
  zone_redundant                = true
  capacity                      = 1
  public_network_access_enabled = false

  network_rule_set {
    default_action                = var.default_action_sbns
    public_network_access_enabled = var.public_network_access_enabled_sbns
    trusted_services_allowed      = var.trusted_services_allowed_sbns
  }

  tags = {
    Environment = var.environment
  }
}
