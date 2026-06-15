variable "subscription_id" {
  type = string
}

variable "enable_containers" {
  type    = bool
  default = true
}

variable "enable_storage" {
  type    = bool
  default = true
}

variable "enable_keyvault" {
  type    = bool
  default = true
}

variable "enable_cosmosdb" {
  type    = bool
  default = true
}

variable "enable_servers" {
  type    = bool
  default = true
}
