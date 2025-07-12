variable "resource_group_name" {
  description = "name of the resource group"
  type   = string
}

variable "location" {
 description = "name of the location"
  type  = string
}

variable "cosmos_account_name" {
  description = "cosmos db account name"
  type  = string
}

variable "cosmos_db_name" {
  description = "Cosmos DB Name"
  type    = string
}

variable "cosmos_container_name" {
  description = "Name of the cosmos db container"
  type = string
}

