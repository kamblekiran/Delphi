output "kv_id" {
  value = azurerm_key_vault.keyvault.id
}

output "vault_uri" {
  value = azurerm_key_vault.keyvault.vault_uri
}

output "keyvault_name" {
  value = azurerm_key_vault.keyvault.name
}
