resource "azurerm_virtual_network_peering" "hubtospoke" {
  name                      = "hubtospokepeering-${var.rg_name}-${var.environment}-${var.location}"
  resource_group_name       = var.rg_name
  virtual_network_name      = var.virtual_network_name
  remote_virtual_network_id = var.remote_virtual_network_id
  allow_forwarded_traffic   = var.allow_forwarded_traffic
  allow_gateway_transit     = var.allow_gateway_transit
  use_remote_gateways       = var.use_remote_gateway
}
