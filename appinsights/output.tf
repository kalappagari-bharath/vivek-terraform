# output "instrumentation_key" {
#   value = azurerm_application_insights.example.instrumentation_key
# }

# output "app_id" {
#   value = azurerm_application_insights.example.app_id
# }

output "appinsights_id" {
  value = azurerm_application_insights.appinsights.id
}

output "app_insights_instrumentation_key" {
  value = azurerm_application_insights.appinsights.instrumentation_key
}