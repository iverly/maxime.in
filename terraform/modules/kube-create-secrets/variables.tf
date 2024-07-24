# Home assistant secrets
variable "home_assistant_access_token" {
  description = "Home assistant access token"
  type        = string
  default     = ""
}

# Linky secrets
variable "linky_prm" {
  description = "Linky PRM"
  type        = string
  default     = ""
}

variable "linky_token" {
  description = "Linky token"
  type        = string
  default     = ""
}
