variable "resource_group_name" {
  description = "The name of the Resource Group"
  type        = string
  default     = "myResourceGroup"
}

variable "location" {
  description = "The Azure location where resources will be created"
  type        = string
  default     = "East US"
}

variable "key_vault_name" {
  description = "The name of the Key Vault"
  type        = string
  default     = "mykeyvault"
}

variable "enabled_for_deployment" {
  description = "Allow Azure services to retrieve secrets from the key vault"
  type        = bool
  default     = false
}

variable "enabled_for_disk_encryption" {
  description = "Allow Azure services to encrypt data with keys stored in the key vault"
  type        = bool
  default     = false
}

variable "soft_delete_retention_days" {
  description = "The number of days to retain deleted vaults"
  type        = number
  default     = 90
}

variable "purge_protection" {
  description = "Enable purge protection"
  type        = bool
  default     = true
}

variable "access_policy" {
  description = "Access policy for the Key Vault"
  type        = map(list(string))
  default = {
    "secrets" = ["get", "list", "set", "delete", "recover", "backup", "restore"]
    "keys"    = ["get", "list", "create", "delete", "decrypt", "encrypt"]
  }
}

variable "network_acls" {
  description = "Network ACLs for the Key Vault"
  type        = map(any)
  default = {
    bypass = ["AzureServices"]
    ip_rules = []
    virtual_networks = []
  }
}
