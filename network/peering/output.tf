output "peering_id" {
  description = "The ID of the  virtual network peering"
  value       = azurerm_virtual_network_peering.hubtospoke.id
}
