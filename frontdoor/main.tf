resource "azurerm_cdn_frontdoor_profile" "my_front_door" {
  name                = var.front_door_profile_name
  resource_group_name = var.rg_name
  sku_name            = var.front_door_sku_name

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_cdn_frontdoor_endpoint" "my_endpoint" {
  name                     = var.front_door_endpoint_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.my_front_door.id
}

resource "azurerm_cdn_frontdoor_endpoint" "mt_endpoint" {
  name                     = var.front_door_endpoint_name_mt
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.my_front_door.id
}

resource "azurerm_cdn_frontdoor_origin_group" "my_origin_group" {
  name                     = var.front_door_origin_group_name
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.my_front_door.id
  session_affinity_enabled = false

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Http"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin_group" "mt_origin_group" {
  name                     = var.front_door_origin_group_name_mt
  cdn_frontdoor_profile_id = azurerm_cdn_frontdoor_profile.my_front_door.id
  session_affinity_enabled = false

  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }

  health_probe {
    path                = "/"
    request_type        = "HEAD"
    protocol            = "Http"
    interval_in_seconds = 100
  }
}

resource "azurerm_cdn_frontdoor_origin" "my_app_service_origin" {
  name                           = var.front_door_origin_name
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.my_origin_group.id
  enabled                        = true
  host_name                      = azurerm_private_link_service.aks.alias
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = azurerm_private_link_service.aks.alias
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
  private_link {
    request_message        = "Request access for Private Link Origin CDN Frontdoor."
    location               = var.location
    private_link_target_id = azurerm_private_link_service.aks.id
  }
  depends_on = [azurerm_private_link_service.aks]
}

resource "azurerm_cdn_frontdoor_origin" "mt_app_service_origin" {
  name                           = var.front_door_origin_name_mt
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.mt_origin_group.id
  enabled                        = true
  host_name                      = var.mt_app_service_origin_host_name
  http_port                      = 80
  https_port                     = 443
  origin_host_header             = var.mt_app_service_origin_host_header
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "my_route" {
  name                          = var.front_door_route_name
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.my_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.my_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.my_app_service_origin.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}

resource "azurerm_cdn_frontdoor_route" "mt_route" {
  name                          = var.front_door_route_name_mt
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.mt_endpoint.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.mt_origin_group.id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.mt_app_service_origin.id]

  supported_protocols    = ["Http", "Https"]
  patterns_to_match      = ["/*"]
  forwarding_protocol    = "HttpOnly"
  link_to_default_domain = true
  https_redirect_enabled = true
}

resource "azurerm_private_link_service" "aks" {
  name                = "pvlink-${var.rg_name_code}-${var.environment}-${var.location}"
  resource_group_name = var.aks_rg
  location            = var.location



  load_balancer_frontend_ip_configuration_ids = var.loadbalancer_id

  nat_ip_configuration {
    name                       = "primary"
    private_ip_address_version = "IPv4"
    subnet_id                  = var.vnet_subnet_id
    primary                    = true
  }

  tags = {
    Environment = var.environment
  }
}
## Approve private endpoint connection from Frontdoor
# resource "null_resource" "approve-fd-endpoint" {
#   provisioner "local-exec" {
#     command     = <<-EOT
#           $connection_name = $(az network private-endpoint-connection list --id ${azurerm_private_link_service.aks.id} --query "[].name") | ConvertFrom-Json
#           az network private-endpoint-connection approve -g ${var.aks_rg} -n $connection_name --resource-name pvlink-${var.rg_name}-${var.environment}-${var.location} --type Microsoft.Network/privateLinkServices --description "Approved"
#         EOT
#     interpreter = ["PowerShell", "-Command"]
#   }

#   depends_on = [azurerm_cdn_frontdoor_origin.my_app_service_origin]
# }
