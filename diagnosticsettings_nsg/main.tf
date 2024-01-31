resource "azurerm_monitor_diagnostic_setting" "diagnostic_settings" {
  name                       = var.diagnosticsettings_name
  target_resource_id         = var.trgid
  log_analytics_workspace_id = var.law

  dynamic "enabled_log" {
    for_each = var.logs
    content {
      category_group = enabled_log.value

      #      retention_policy {
      #   enabled = false
      # }
    }
  }
}
