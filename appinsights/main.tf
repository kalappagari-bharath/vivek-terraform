resource "azurerm_application_insights" "appinsights" {
  name                = var.app_insight_name
  location            = var.location
  resource_group_name = var.rg_name
  workspace_id        = var.law_id
  application_type    = "web"

  tags = {
    Environment = var.environment
  }
}
