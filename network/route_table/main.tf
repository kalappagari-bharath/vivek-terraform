resource "azurerm_route_table" "route_table" {
  name                = var.route_table_name
  location            = var.location
  resource_group_name = var.rg_name

  tags = {
    Environment = var.environment
  }

  route {
    name           = var.route_name
    address_prefix = var.address_prefix_routetable
    next_hop_type  = "VnetLocal"
  }
}

resource "azurerm_subnet_route_table_association" "routetable_association" {
  subnet_id      = var.subnet_id
  route_table_id = azurerm_route_table.route_table.id
}
