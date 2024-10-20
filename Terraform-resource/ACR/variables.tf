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

variable "acr_name" {
  description = "The name of the Azure Container Registry"
  type        = string
  default     = "myacrregistry"
}

variable "sku" {
  description = "The SKU for the ACR"
  type        = string
  default     = "Basic"
}

variable "enable_admin_access" {
  description = "Enable admin access for the ACR"
  type        = bool
  default     = false  # Best practice is to disable admin access
}

variable "enable_geo_replication" {
  description = "Enable geo-replication for ACR"
  type        = bool
  default     = false
}

variable "replication_locations" {
  description = "Additional locations for geo-replication"
  type        = list(string)
  default     = []
}
