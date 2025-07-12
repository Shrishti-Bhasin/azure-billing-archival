variable "resource_group_name" {
  description = "name of the resource group"
  type   = string
}

variable "location" {
 description = "name of the location"
  type  = string
}

variable "app_service_plan" {
  description = "Name of the app service plan"
  type        = string
}

variable "function_app_name" {
  description = "Name of the function app"
  type        = string 
}
