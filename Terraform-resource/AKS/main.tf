resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = var.aks_name

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.node_size
    enable_auto_scaling = true
    max_count = 5
    min_count = 1
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"  # Use Calico for network policies
    pod_cidr = "10.244.0.0/16"  # Customize as needed
    service_cidr = "10.0.0.0/16" # Customize as needed
  }

  api_server_authorized_ip_ranges = ["<your-ip-address>/32"] # Limit access to the API server

  # Enable private cluster
  private_cluster_enabled = var.enable_private_cluster

  # Azure AD integration
  azure_active_directory {
    admin_group_object_ids = var.aad_admin_group_object_ids
  }

  monitoring {
    enabled = true
    log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
  }

  tags = {
    Environment = "Production"
    Project     = "AKS"
  }
}

resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.resource_group_name}-law"
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  sku                 = "PerGB2018"

  retention_in_days = 30
}

output "kube_admin_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_admin_config
  sensitive = true
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.aks.kube_config
  sensitive = true
}
