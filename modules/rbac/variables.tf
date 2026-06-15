variable "subscription_id" {
  type = string
}

variable "aks_principal_id" {
  type = string
}

variable "github_principal_id" {
  type = string
}

variable "acr_id" {
  type = string
}

variable "keyvault_id" {
  type = string
}

variable "storage_account_id" {
  type = string
  default = null
}

variable "cosmosdb_id" {
  type = string
  default = null
}
