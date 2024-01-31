resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = var.node_pool_name
  kubernetes_cluster_id = var.aks_id
  vm_size               = var.vm_size
  node_count            = var.node_count
  vnet_subnet_id        = var.vnet_subnet_id
  

}
