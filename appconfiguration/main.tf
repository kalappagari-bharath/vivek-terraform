resource "azurerm_app_configuration" "appconfigu" {
  name                  = var.app_config_name
  resource_group_name   = var.rg_name
  location              = var.location
  sku                   = var.sku_name
  local_auth_enabled    = true
  public_network_access = "Enabled"

  tags = {
    Environment = var.environment
  }
}
