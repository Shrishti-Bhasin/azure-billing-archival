provider "azurerm" {
  features {}
}

module "cosmos_db" {
  source = "./modules/cosmos_db"

  location = var.location
  resource_group_name = var.resource_group_name
  cosmos_account_name = var.cosmos_account_name
  cosmos_db_name  = var.cosmos_db_name
  cosmos_container_name = var.cosmos_container_name
}

module "storage_account" {
  source = "./modules/storage_account"
  location = var.location
  resource_group_name = var.resource_group_name
  storage_account_name = var.storage_account_name
  storage_account_container_name = var.storage_account_container_name
}

module "application_insights" {
  source = "./modules/application_insights"

  location = var.location
  resource_group_name = var.resource_group_name
  app_insights_name = var.app_insights_name
}

module "function_app" {
  source = "./modules/function_app"

  location = var.location
  resource_group_name = var.resource_group_name
  app_service_plan = var.app_service_plan
  function_app_name = var.function_app_name
}
