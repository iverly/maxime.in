output "kubeconfig" {
  value = k0s_cluster.this.kubeconfig
}

output "controller_ips" {
  value = local.controller_ips
}
