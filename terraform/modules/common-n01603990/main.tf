resource "azurerm_log_analytics_workspace" "workspace" {
  location            = var.location
  resource_group_name = var.rg-name
  name                = var.workspace_name
}

resource "azurerm_recovery_services_vault" "vault" {
  name                = var.vault_name
  location            = var.location
  resource_group_name = var.rg-name
  sku                 = "Standard"
}

resource "azurerm_storage_account" "storageaccount" {
  location                 = var.location
  resource_group_name      = var.rg-name
  name                     = var.storage_account_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}