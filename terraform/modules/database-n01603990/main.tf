resource "azurerm_postgresql_server" "assignment_db" {
  name                = var.db_name
  location            = var.location
  resource_group_name = var.rg-name
  sku_name = var.sku_name
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  version                      = var.pversion
  ssl_enforcement_enabled      = true
  tags = local.tags
}