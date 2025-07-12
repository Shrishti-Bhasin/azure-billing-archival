variable "resource_group_name" {
  description = "name of the resource group"
  type   = string
}

variable "location" {
 description = "name of the location"
  type  = string
}

variable "storage_account_name" {
  description = "Name of the storage account"
  type = string
}

variable "storage_account_container_name" {
  description = "Name of blob container"
  type  = string
}
