terraform {
  backend "azurerm" {
    resource_group_name  = "tfstaten01603990RG"
    storage_account_name = "tfstaten01603990sa"
    container_name       = "assignment"
    key                  = "terraform.tfstate"
  }
}