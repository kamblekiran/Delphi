output "acr_login_server" {
  description = "The login server for the Azure Container Registry"
  value       = azurerm_container_registry.acr.login_server
}

output "acr_id" {
  description = "The ID of the Azure Container Registry"
  value       = azurerm_container_registry.acr.id
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.acr_rg.name
}
