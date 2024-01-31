terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
    }
  }
}

provider "kubectl" {
  host                   = var.host
  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  load_config_file       = false
}

resource "kubectl_manifest" "internal-loadbalancer" {
  yaml_body = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: internal-loadbalancer
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-internal: "true"
spec:
  type: LoadBalancer
  ports:
  - port: 80
  selector:
    ${var.selector}
YAML
}

resource "time_sleep" "wait_3_minutes" {
  depends_on = [kubectl_manifest.internal-loadbalancer]

  create_duration = "3m"
}

data "azurerm_lb" "internal-lb" {
  name                = "kubernetes-internal"
  resource_group_name = var.aks_rg

  depends_on = [time_sleep.wait_3_minutes]
}
