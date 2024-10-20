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

variable "aks_name" {
  description = "The name of the AKS cluster"
  type        = string
  default     = "myAKSCluster"
}

variable "node_count" {
  description = "The number of nodes in the AKS cluster"
  type        = number
  default     = 3
}

variable "node_size" {
  description = "The size of the nodes in the AKS cluster"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "kubernetes_version" {
  description = "The Kubernetes version for the AKS cluster"
  type        = string
  default     = "1.24.6"
}

variable "enable_private_cluster" {
  description = "Enable a private AKS cluster"
  type        = bool
  default     = true
}

variable "aad_admin_group_object_ids" {
  description = "The AAD Group Object IDs to grant access to the AKS cluster"
  type        = list(string)
  default     = []
}
