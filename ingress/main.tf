provider "helm" {
  kubernetes {
    host                   = var.host
    client_certificate     = base64decode(var.client_certificate)
    client_key             = base64decode(var.client_key)
    cluster_ca_certificate = base64decode(var.cluster_ca_certificate)
    # config_path            = "~/.kube/config"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress-controller"
  namespace  = "default"
  repository = "https://kubernetes.github.io/ingress-nginx/"
  #version    = "1.9.4"
  chart = "ingress-nginx"

  //depends_on = [kubernetes_namespace.development]
}
