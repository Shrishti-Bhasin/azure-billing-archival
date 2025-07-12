resource "azurerm_resource_group" "example" {
  name     = "var.resource_group_name"
  location = "var.location"
}

resource "azurerm_storage_account" "blob" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "archive" {
  name                  = var.storage_account_container_name
  storage_account_name  = azurerm_storage_account.blob.name
  container_access_type = "private"
}

