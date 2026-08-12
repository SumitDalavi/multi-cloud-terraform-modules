resource "azurerm_kubernetes_cluster" "this" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.cluster_name
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name       = "system"
    node_count = var.system_node_count
    vm_size    = var.system_vm_size
  }

  identity { type = "SystemAssigned" }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
  }

  tags = merge(var.tags, { ManagedBy = "terraform-module-registry" })
}

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = var.user_vm_size
  node_count            = var.user_node_count
  mode                  = "User"
  tags                  = var.tags
}

variable "cluster_name"        { type = string }
variable "location"            { type = string; default = "East US" }
variable "resource_group_name" { type = string }
variable "kubernetes_version"  { type = string; default = "1.28" }
variable "system_node_count"   { type = number; default = 2 }
variable "system_vm_size"      { type = string; default = "Standard_DS2_v2" }
variable "user_node_count"     { type = number; default = 2 }
variable "user_vm_size"        { type = string; default = "Standard_DS2_v2" }
variable "tags"                { type = map(string); default = {} }

output "cluster_id"  { value = azurerm_kubernetes_cluster.this.id }
output "kube_config" { value = azurerm_kubernetes_cluster.this.kube_config_raw; sensitive = true }
