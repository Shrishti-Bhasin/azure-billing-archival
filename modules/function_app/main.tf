resource "azurerm_resource_group" "azure" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_service_plan" "plan" {
  name                = var.app_service_plan
  location            = azurerm_resource_group.azure.location
  resource_group_name = azurerm_resource_group.azure.name
  os_type             = "Linux"
  sku_name            = "Y1" # Consumption plan
}

resource "azurerm_linux_function_app" "function" {
  name                       = var.function_app_name
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  service_plan_id            = azurerm_service_plan.plan.id
  storage_account_name       = azurerm_storage_account.blob.name
  storage_account_access_key = azurerm_storage_account.blob.primary_access_key
  # application_insights_key   = azurerm_application_insights.insights.instrumentation_key

  site_config {
    application_stack {
      python_version = "3.10"
    }
  }

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME         = "python"
    APPINSIGHTS_INSTRUMENTATIONKEY   = azurerm_application_insights.insights.instrumentation_key
    COSMOS_ENDPOINT                  = azurerm_cosmosdb_account.cosmos.endpoint
    COSMOS_KEY                       = azurerm_cosmosdb_account.cosmos.primary_key
    BLOB_CONN                        = azurerm_storage_account.blob.primary_connection_string
  }
}
