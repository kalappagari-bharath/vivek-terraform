resource "azurerm_servicebus_queue" "sbq" {
  name                = var.servicebus_queue_name
  namespace_id        = var.servicebus_id
  enable_partitioning = false
}
