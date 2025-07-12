resource "azurerm_resource_group" "main" {
  name     = "var.resource_group_name"
  location = "var.location"
}

resource "azurerm_application_insights" "insights" {
  name                = var.app_insights_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  application_type    = "web"
}

