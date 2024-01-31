resource "azurerm_network_security_rule" "nsgrule" {
  name                        = var.nsgrule_name
  priority                    = var.priority                   #100
  direction                   = var.direction                  #"Inbound"
  access                      = var.access                     #"Allow"
  protocol                    = var.protocol                   #"Tcp"
  source_port_range           = var.source_port_range          #"*"
  destination_port_range      = var.destination_port_range     #"80"
  source_address_prefix       = var.source_address_prefix      #"*"
  destination_address_prefix  = var.destination_address_prefix #"*"
  resource_group_name         = var.rg_name
  network_security_group_name = var.nsg_name
}
