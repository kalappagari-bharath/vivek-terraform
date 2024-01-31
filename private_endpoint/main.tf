resource "azurerm_private_endpoint" "pep" {
  name                = var.private_endpoint_name
  resource_group_name = var.rg_name
  location            = var.location
  subnet_id           = var.subnet_id



  private_service_connection {
    name                           = var.private_service_connection_name
    private_connection_resource_id = var.private_connection_resource_id
    is_manual_connection           = false
    subresource_names              = var.subresource_names
  }


  private_dns_zone_group {
    name                 = var.private_dns_zone_group_name
    private_dns_zone_ids = [azurerm_private_dns_zone.dnsz.id]
  }

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_private_dns_zone" "dnsz" {
  name                = var.private_dns_zone_name
  resource_group_name = var.rg_name
}

resource "azurerm_private_dns_a_record" "dnsarecord" {
  name                = var.private_dns_a_record_name
  zone_name           = azurerm_private_dns_zone.dnsz.name
  resource_group_name = var.rg_name
  ttl                 = 300
  records             = var.private_dns_a_record_records
}

resource "azurerm_private_dns_zone_virtual_network_link" "pvtdnszonevnet" {
  name                  = var.private_dns_zone_virtual_network_link_name
  resource_group_name   = var.rg_name
  private_dns_zone_name = azurerm_private_dns_zone.dnsz.name
  virtual_network_id    = var.private_dns_zone_virtual_network_link_virtual_network_id
}



