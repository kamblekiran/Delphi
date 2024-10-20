resource "azurerm_resource_group" "keyvault_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_key_vault" "keyvault" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.keyvault_rg.location
  resource_group_name         = azurerm_resource_group.keyvault_rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"  # Use 'premium' if you need additional features

  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled     = var.purge_protection

  enabled_for_deployment      = var.enabled_for_deployment
  enabled_for_disk_encryption  = var.enabled_for_disk_encryption

  network_acls {
    bypass              = var.network_acls.bypass
    ip_rules           = var.network_acls.ip_rules
    virtual_network_subnet_ids = var.network_acls.virtual_networks
  }

  tags = {
    Environment = "Dev"
    Project     = "KeyVault"
  }
}

# Assign Access Policies
resource "azurerm_key_vault_access_policy" "example" {
  count       = length(var.access_policy["secrets"])
  key_vault_id = azurerm_key_vault.keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = "<your-object-id>"  # Replace with the object ID of the service principal or user

  secret_permissions = var.access_policy["secrets"]
  key_permissions    = var.access_policy["keys"]
}

data "azurerm_client_config" "current" {}
