resource "kubernetes_namespace_v1" "flux-system" {
  metadata {
    name = "flux-system"
  }
}

resource "kubernetes_namespace_v1" "cert-manager" {
  metadata {
    name = "cert-manager"
  }
}

resource "kubernetes_namespace_v1" "dns" {
  metadata {
    name = "dns"
  }
}

resource "kubernetes_namespace_v1" "minecraft" {
  metadata {
    name = "minecraft"
  }
}
