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

  name  = "maxime-in-k0s"
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

module "flux_install" {
  source = "./modules/kube-flux-install"

  name      = "maxime-in-flux-sync"
  path      = "cluster"
  namespace = "flux-system"
  git_url   = "https://github.com/iverly/maxime.in"

  depends_on = [module.k0s_cluster, module.create_namespaces]
}

module "create_secrets" {
  source = "./modules/kube-create-secrets"
  count  = var.create_secrets == true ? 1 : 0

  home_assistant_access_token = var.secrets_home_assistant_access_token

  linky_prm   = var.secrets_linky_prm
  linky_token = var.secrets_linky_token

  depends_on = [module.k0s_cluster, module.create_namespaces]
}
