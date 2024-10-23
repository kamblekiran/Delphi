output "rg_name_out" {
  value = module.ResourceGroup.rg_name_out
} 
output "Azure_webapp_name" {
  value = module.Webapp.Azure_webapp_name
}
output "keyvault_name" {
  value = module.keyvault.keyvault_name
}
output "registry_name" {
  value = module.ACR.registry_name   
}
output "kubernetes_cluster_name" {
  value = module.AKS.kubernetes_cluster_name
}