resource "azurerm_monitor_workspace" "amw" {
  name                = var.amw_name
  resource_group_name = var.rg_name
  location            = var.location

  tags = {
    Environment = var.environment
  }
}
