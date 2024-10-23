

module "ResourceGroup" {
  source              = "./module/ResourceGroup"
  resource_group_name = "Delphi"
  resource_group_location = "West Europe"

}


module "Webapp" {
  source              = "./module/Webapp"
  resource_group_name = module.ResourceGroup.rg_name_out
  resource_group_location = module.ResourceGroup.rg_location_out
  OS_TYPE = "Linux"
  SKU_NAME =  "S1"
  WEBAPP_PLAN_NAME = "Webapp-plan"
  WEBAPPNAME      =   "Webapp-78612345"
  APP_AUTOSCALE =   "Webapp-autoscale"
  CUSTOM_EMAILS =    "tst@gmail.com"
  depends_on = [module.ResourceGroup]

}

module "keyvault" {
  source              = "./module/KeyVault"
  resource_group_name = module.ResourceGroup.rg_name_out
  resource_group_location = module.ResourceGroup.rg_location_out
  keyvault_name          = "demokv01090786"
  secret_name            = "DatabasePassword"
  secret_value           = "@Aa123456789!"
  depends_on = [module.ResourceGroup]

}

module "ACR" {
  source              = "./module/ACR"
  resource_group_name = module.ResourceGroup.rg_name_out
  resource_group_location = module.ResourceGroup.rg_location_out
  registry_name       = "demotf001acr"
  sku                 = "Basic"
  log_analytics_workspace = "demotf786-law"
  depends_on = [module.ResourceGroup]

}

module "AKS" {
  source              = "./module/AKS"
  resource_group_name = module.ResourceGroup.rg_name_out
  resource_group_location = module.ResourceGroup.rg_location_out
  node_count     = "3"
  username       = "azureadmin"
  resource_group_id = module.ResourceGroup.rg_name_id
  depends_on = [module.ResourceGroup]

}

