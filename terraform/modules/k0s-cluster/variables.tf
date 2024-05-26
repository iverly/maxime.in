variable "name" {
  description = "Name of the k0s cluster"
  type        = string
}

variable "hosts" {
  description = "List of hosts to deploy k0s cluster on"
  type = list(object({
    role          = string
    address       = string
    port          = string
    user          = string
    no_taints     = bool
    install_flags = list(string)
  }))
}
