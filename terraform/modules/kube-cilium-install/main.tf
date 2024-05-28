resource "helm_release" "this" {
  name = "cilium"

  repository = "https://helm.cilium.io"
  chart      = "cilium"
  version    = "1.15.5"

  namespace = var.namespace
  wait      = false # do not wait for cilium to be ready because
  # we don't have load balancer and storage class yet

  set {
    name  = "operator.replicas"
    value = "1"
  }

  # replace kube-proxy
  set {
    name  = "kubeProxyReplacement"
    value = "true"
  }

  set {
    name  = "routingMode"
    value = "tunnel"
  }

  set {
    name  = "tunnelProtocol"
    value = "vxlan"
  }

  set {
    name  = "k8sServiceHost"
    value = var.controller_ip
  }

  set {
    name  = "k8sServicePort"
    value = 6443
  }

  # use kubernetes mode for IPAM
  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }

  # use l2 advertisement for service IPs
  set {
    name  = "l2announcements.enabled"
    value = "true"
  }

  # rate limit
  set {
    name  = "k8sClientRateLimit.qps"
    value = "100"
  }

  set {
    name  = "k8sClientRateLimit.burst"
    value = "200"
  }
}
