variable "resource_group_name" {
  default = "billing-records-rg"
}

variable "location" {
  type    = string
  default = "East US"
}

variable "storage_account_name" {
  default = "billingrecordssa"
}

variable "storage_account_container_name" {
  default = "billing-archival"
}

variable "cosmos_account_name" {
  default = "billingrecordscosmosacc"
}

variable "cosmos_db_name" {
  default = "billingrecordsdb"
}

variable "cosmos_container_name" {
  default = "billingrecords"
}

variable "app_insights_name" {
 default = "billing-records-app-insights" 
}

variable "app_service_plan" {
  default = "billing-records-service-plan"
}

variable "function_app_name" {
  default = "billing-records-fun-app" 
}
