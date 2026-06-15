variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "publisher_name" {
  type = string
}

variable "publisher_email" {
  type = string
}

variable "virtual_network_type" {
  type    = string
  default = "Internal"
}

variable "appgw_subnet_id" {
  type = string
}

variable "tags" {
  type = map(string)
}
