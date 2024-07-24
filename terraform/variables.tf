############################################
#                 Secrets                  #
############################################
variable "create_secrets" {
  description = "Create secrets in the cluster"
  type        = bool
  default     = false
}

# Home assistant secrets
variable "secrets_home_assistant_access_token" {
  description = "Home assistant access token"
  type        = string
  default     = ""
}

# Linky secrets
variable "secrets_linky_prm" {
  description = "Linky PRM"
  type        = string
  default     = ""
}

variable "secrets_linky_token" {
  description = "Linky token"
  type        = string
  default     = ""
}
