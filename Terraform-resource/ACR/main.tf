resource "azurerm_resource_group" "acr_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  location            = azurerm_resource_group.acr_rg.location
  resource_group_name = azurerm_resource_group.acr_rg.name
  sku                 = var.sku
  admin_enabled       = var.enable_admin_access  # Disable by default

  # Enable diagnostic settings for monitoring
  diagnostic_settings {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
    logs {
      category = "ContainerRegistryLogin"
      enabled  = true
    }
    logs {
      category = "ContainerRegistryRepositories"
      enabled  = true
    }
  }

  tags = {
    Environment = "Dev"
    Project     = "ACR"
  }
}

# Optional: Configure geo-replication for high availability
resource "azurerm_container_registry_geo_replication" "acr_geo_replication" {
  count              = var.enable_geo_replication ? length(var.replication_locations) : 0
  registry_name      = azurerm_container_registry.acr.name
  resource_group_name = azurerm_resource_group.acr_rg.name
  location           = var.replication_locations[count.index]
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.resource_group_name}-law"
  location            = azurerm_resource_group.acr_rg.location
  resource_group_name = azurerm_resource_group.acr_rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

output "acr_login_server" {
  description = "Login server URL for the ACR"
  value       = azurerm_container_registry.acr.login_server
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.acr_rg.name
}
