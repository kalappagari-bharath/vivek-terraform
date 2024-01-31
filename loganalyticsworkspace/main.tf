resource "azurerm_log_analytics_workspace" "log" {
  name                = var.law_name
  location            = var.location
  resource_group_name = var.rg_name
  #sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = var.environment
  }
}
