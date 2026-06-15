variable "cluster_name" {
  type = string
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "acr_id" {
  type = string
}

variable "log_analytics_workspace_id" {
  type = string
}

variable "grafana_id" {
  type = string
}

variable "kubernetes_version" {
  type = string
  default = "1.31"
}

variable "tags" {
  type = map(string)
}
