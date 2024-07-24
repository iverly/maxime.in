############################################
#             Home assistant               #
############################################
resource "kubernetes_secret_v1" "home-assistant-credentials" {
  metadata {
    name      = "home-assistant-credentials"
    namespace = "home-assistant"
  }

  data = {
    access_token = var.home_assistant_access_token
  }
}

resource "kubernetes_secret_v1" "this" {
  metadata {
    name      = "linky-credentials"
    namespace = "home-assistant"
  }

  data = {
    prm   = var.linky_prm
    token = var.linky_token
  }
}
