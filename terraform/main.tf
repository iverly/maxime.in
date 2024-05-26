locals {
  inventory = yamldecode(file("inventory.yaml"))

  hosts = flatten([
    for role, group in local.inventory : [
      for host in group.hosts : {
        role          = role
        address       = host.address
        port          = host.port
        user          = host.user
        no_taints     = host.no_taints
        install_flags = host.install_flags
      }
    ]
  ])
}

module "k0s_cluster" {
  source = "./modules/k0s-cluster"

  name  = "area-51-k0s"
  hosts = local.hosts
}

locals {
  kube_config = yamldecode(module.k0s_cluster.kubeconfig)
}

provider "kubernetes" {
  host                   = local.kube_config.clusters[0].cluster.server
  cluster_ca_certificate = base64decode(local.kube_config.clusters[0].cluster.certificate-authority-data)
  client_certificate     = base64decode(local.kube_config.users[0].user.client-certificate-data)
  client_key             = base64decode(local.kube_config.users[0].user.client-key-data)
}

provider "helm" {
  kubernetes {
    host                   = local.kube_config.clusters[0].cluster.server
    cluster_ca_certificate = base64decode(local.kube_config.clusters[0].cluster.certificate-authority-data)
    client_certificate     = base64decode(local.kube_config.users[0].user.client-certificate-data)
    client_key             = base64decode(local.kube_config.users[0].user.client-key-data)
  }
}

module "create_namespaces" {
  source = "./modules/kube-create-namespaces"

  depends_on = [module.k0s_cluster]
}

module "cilium_install" {
  source = "./modules/kube-cilium-install"

  controller_ip = module.k0s_cluster.controller_ips[0]
  namespace     = "kube-system"

  depends_on = [module.k0s_cluster, module.create_namespaces]
}

module "flux_install" {
  source = "./modules/kube-flux-install"

  name      = "area-51-flux-sync"
  path      = "cluster"
  namespace = "flux-system"
  git_url   = "https://github.com/iverly/area-51"

  depends_on = [module.k0s_cluster, module.create_namespaces, module.cilium_install]
}
