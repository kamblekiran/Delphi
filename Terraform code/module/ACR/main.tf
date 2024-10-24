locals {
  # Store gepreplications in map where key is location.
  # This automatically sorts the map by location.
  georeplications = {
    for georeplication in var.georeplications : georeplication.location => georeplication
  }

  diagnostic_setting_metric_categories = ["AllMetrics"]
}

resource "azurerm_container_registry" "this" {
  name                          = var.registry_name
  location                      = var.resource_group_location
  resource_group_name           = var.resource_group_name
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  public_network_access_enabled = var.public_network_access_enabled
  network_rule_bypass_option    = var.network_rule_bypass_azure_services ? "AzureServices" : "None"

  dynamic "network_rule_set" {
    for_each = var.sku == "Premium" ? [0] : []

    content {
      default_action = var.network_rule_set_default_action

      ip_rule = [
        for ip_range in var.network_rule_set_ip_rules : {
          action   = "Allow" # Only supported value
          ip_range = ip_range
        }
      ]
    }
  }

  dynamic "georeplications" {
    for_each = local.georeplications

    content {
      location                = georeplications.value["location"]
      zone_redundancy_enabled = georeplications.value["zone_redundancy_enabled"]
    }
  }

  tags = var.tags

  lifecycle {
    # Prevent accidental destroy of Container Registry.
    prevent_destroy = true

    precondition {
      condition     = var.sku == "Premium" ? length(var.georeplications) >= 0 : length(var.georeplications) == 0
      error_message = "Geo-replications can only be configured if SKU is \"Premium\"."
    }
  }
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = var.log_analytics_workspace
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}


resource "azurerm_monitor_diagnostic_setting" "this" {
  name                       = var.diagnostic_setting_name
  target_resource_id         = azurerm_container_registry.this.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  # Ref: https://registry.terraform.io/providers/hashicorp/azurerm/3.65.0/docs/resources/monitor_diagnostic_setting#log_analytics_destination_type
  log_analytics_destination_type = null

  dynamic "enabled_log" {
    for_each = toset(var.diagnostic_setting_enabled_log_categories)

    content {
      category = enabled_log.value
    }
  }

  dynamic "metric" {
    for_each = toset(concat(local.diagnostic_setting_metric_categories, var.diagnostic_setting_enabled_metric_categories))

    content {
      # Azure expects explicit configuration of both enabled and disabled metric categories.
      category = metric.value
      enabled  = contains(var.diagnostic_setting_enabled_metric_categories, metric.value)
    }
  }
}