provider "kubernetes" {
  host                   = var.host
  client_certificate     = base64decode(var.client_certificate)
  client_key             = base64decode(var.client_key)
  cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
  # config_path            = "~/.kube/config"
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace_name
  }
}
