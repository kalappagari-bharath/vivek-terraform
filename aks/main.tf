data "azurerm_user_assigned_identity" "aks_mi" {
  name                = var.mi_name
  resource_group_name = var.rg_name
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                    = var.aks_name
  location                = var.location
  resource_group_name     = var.rg_name
  dns_prefix              = var.aks_name
  private_cluster_enabled = var.private_cluster_enabled

  default_node_pool {
    name           = "system"
    node_count     = 2
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = var.vnet_subnet_id
  }

  monitor_metrics {

  }

  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.aks_mi.id]
  }

  kubelet_identity {
    client_id                 = data.azurerm_user_assigned_identity.aks_mi.client_id
    object_id                 = data.azurerm_user_assigned_identity.aks_mi.principal_id
    user_assigned_identity_id = data.azurerm_user_assigned_identity.aks_mi.id
  }

  oms_agent {
    log_analytics_workspace_id = var.law_id
  }


  network_profile {
    load_balancer_sku   = "standard"
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = "calico"
  }

  tags = {
    Environment = var.environment
  }
}
