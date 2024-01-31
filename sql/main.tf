resource "azurerm_mssql_server" "sql" {
  name                         = var.sql_name
  resource_group_name          = var.rg_name
  location                     = var.location
  version                      = var.version_sql
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  public_network_access_enabled = true

  tags = {
    Environment = var.environment
  }
}
