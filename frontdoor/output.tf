output "afd_id" {
  value = azurerm_cdn_frontdoor_profile.my_front_door.id
}

output "frontend_endpoint_name" {
  value = azurerm_cdn_frontdoor_endpoint.my_endpoint.id
}
