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

variable "app_service_plan_name" {
  description = "The name of the App Service Plan"
  type        = string
  default     = "myAppServicePlan"
}

variable "web_app_name" {
  description = "The name of the Web App"
  type        = string
  default     = "mywebapp"
}

variable "sku" {
  description = "The SKU for the App Service Plan"
  type        = string
  default     = "S1"  # Standard tier
}

variable "app_settings" {
  description = "Application settings for the Web App"
  type        = map(string)
  default     = {
    "WEBSITE_NODE_DEFAULT_VERSION" = "14"
    "NODE_ENV"                     = "production"
  }
}

variable "enable_backup" {
  description = "Enable backup for the web app"
  type        = bool
  default     = true
}

variable "backup_schedule" {
  description = "Backup schedule configuration"
  type        = object({
    frequency = string
    retention = number
  })
  default = {
    frequency = "P1D"  # Daily backups
    retention = 30      # Retain backups for 30 days
  }
}
