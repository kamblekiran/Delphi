output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks.name
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.aks_rg.name
}

output "kube_admin_config" {
  description = "Kubernetes Admin Config"
  value       = azurerm_kubernetes_cluster.aks.kube_admin_config
  sensitive   = true
}
