resource "azurerm_cosmosdb_account" "cosnodb" {
  name                = var.cosnodb_name
  location            = var.location
  resource_group_name = var.rg_name
  offer_type          = var.offer_type
  kind                = var.kind
  public_network_access_enabled = false

  consistency_policy {
    consistency_level = var.consistency_level
  }

  geo_location {
    location          = var.geo_location
    failover_priority = var.failover_priority

  }

  tags = {
    Environment = var.environment
  }
}
