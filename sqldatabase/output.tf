# output "sql_server_id" {
#   value = azurerm_mssql_server.sql.id
# }
output "sql_database_id" {
  value = azurerm_mssql_database.sqldatabase.id
}