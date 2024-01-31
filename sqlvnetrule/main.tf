resource "azurerm_mssql_virtual_network_rule" "sql-vnet-rule" {
  name                                 = var.sql_vnet_rule_name
  server_id                            = var.server_id_sql
  subnet_id                            = var.subnet_id_sql_vnet_rule
  ignore_missing_vnet_service_endpoint = var.ignore_missing_vnet_service_endpoint
}
