locals {
  controller_ips = [for host in var.hosts : host.address if host.role == "controller" || host.role == "controller+worker"]

  k0s_hosts = [for host in var.hosts : {
    role          = host.role
    no_taints     = host.no_taints
    install_flags = host.install_flags
    ssh = {
      address = host.address
      port    = host.port
      user    = host.user
    }
  }]
}

resource "k0s_cluster" "this" {
  name    = var.name
  version = "1.29.3+k0s.0"

  hosts   = local.k0s_hosts
  no_wait = true # Don't wait for the nodes to be ready there is no cni

  config = <<EOT
apiVersion: k0s.k0sproject.io/v1beta1
kind: ClusterConfig
metadata:
  name: ${var.name}
spec:
  api:
    sans: [${join(", ", local.controller_ips)}, 127.0.0.1]
  network:
    provider: custom
    podCIDR: 10.142.0.0/16
    serviceCIDR: 10.143.0.0/16
    kubeProxy:
      disabled: true
EOT
}
