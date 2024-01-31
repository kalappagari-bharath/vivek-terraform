resource "azurerm_mssql_database" "sqldatabase" {
  name      = var.sql_database_name
  server_id = var.server_id_sql
}
