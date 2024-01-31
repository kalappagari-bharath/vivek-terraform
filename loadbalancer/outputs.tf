output "loadbalancer_id" {
  value = [data.azurerm_lb.internal-lb.frontend_ip_configuration[0].id]
}

output "loadbalancer_ip" {
  value = [data.azurerm_lb.internal-lb.frontend_ip_configuration[0].private_ip_address]
}
