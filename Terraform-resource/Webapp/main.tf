resource "azurerm_resource_group" "app_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name

  sku {
    tier     = "Standard"
    size     = var.sku
  }

  # Enable autoscaling
  maximum_elastic_worker_count = 1
  reserved                     = true  # For Linux App Services
}

resource "azurerm_web_app" "web_app" {
  name                = var.web_app_name
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id

  app_settings = var.app_settings

  site_config {
    always_on = true  # Keep the app loaded at all times
  }

  tags = {
    Environment = "Dev"
    Project     = "WebApp"
  }
}

# Optional: Set up Application Insights for monitoring
resource "azurerm_application_insights" "app_insights" {
  name                = "${var.web_app_name}-insights"
  location            = azurerm_resource_group.app_rg.location
  resource_group_name = azurerm_resource_group.app_rg.name
  application_type    = "web"
}

# Backup configuration
resource "azurerm_web_app_backup" "backup" {
  count              = var.enable_backup ? 1 : 0
  web_app_id        = azurerm_web_app.web_app.id
  storage_account_url = "<your-storage-account-url>"  # Replace with your storage account URL

  backup_schedule {
    frequency = var.backup_schedule.frequency
    retention = var.backup_schedule.retention
  }
}

# Output for web app URL
output "web_app_url" {
  description = "The URL of the Web App"
  value       = azurerm_web_app.web_app.default_site_hostname
}
