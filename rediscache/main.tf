resource "azurerm_redis_cache" "rediscache" {
  name                = var.redis_name
  location            = var.location
  resource_group_name = var.rg_name
  capacity            = var.capacity
  family              = var.family_redis
  sku_name            = var.sku_name_redis
  enable_non_ssl_port = var.enable_non_ssl_port
  minimum_tls_version = "1.2"
  public_network_access_enabled = "false"

  tags = {
    Environment = var.environment
  }

  redis_configuration {
  }
  
}

