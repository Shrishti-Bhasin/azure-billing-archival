output "function_app_url" {
  value = azurerm_linux_function_app.function.default_hostname
}
