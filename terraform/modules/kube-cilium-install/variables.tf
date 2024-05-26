variable "namespace" {
  description = "The namespace to install the Helm release"
  type        = string
}

variable "controller_ip" {
  description = "The address of the Kubernetes controller"
  type        = string
}
