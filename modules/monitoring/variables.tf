variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "log_analytics_name" {
  type = string
}

variable "monitor_workspace_name" {
  type = string
}

variable "grafana_name" {
  type = string
}

variable "private_endpoint_subnet_id" {
  type = string
}

variable "monitor_private_dns_zone_id" {
  type = string
}

variable "tags" {
  type = map(string)
}
