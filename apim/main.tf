resource "azurerm_api_management" "apim" {
  name                 = var.apim_name
  location             = var.location
  resource_group_name  = var.rg_name
  publisher_name       = var.apim_publisher_name
  publisher_email      = var.apim_publisher_email
  sku_name             = var.apim_sku_name
  virtual_network_type = var.apim_virtual_network_type
  public_ip_address_id = azurerm_public_ip.apim_pip.id
  virtual_network_configuration {
    subnet_id = var.subnet_id
  }

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_public_ip" "apim_pip" {
  name                = var.apim_pip_name
  resource_group_name = var.rg_name
  location            = var.location
  sku                 = "Standard"
  allocation_method   = "Static"
  domain_name_label   = var.domain_name_label

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_api_management_logger" "appinsights" {
  name = var.apim_appinsight_name
  api_management_name = var.apim_name
  resource_group_name = var.rg_name
  application_insights {
    instrumentation_key = var.instrumentation_key
  }
}
