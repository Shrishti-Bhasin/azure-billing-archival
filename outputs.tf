output "cosmosdb_endpoint" {
  value = module.cosmos_db.endpoint
}

output "storage_account_blob_endpoint" {
  value = module.storage_account.blob_endpoint
}

output "function_app_url" {
  value = module.function_app.function_app_url
}
