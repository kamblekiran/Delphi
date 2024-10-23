output "Azure_plan_name" {
    value = azurerm_service_plan.webplan.name
  
}

output "Azure_webapp_name" {
  value = azurerm_linux_web_app.app.name
}