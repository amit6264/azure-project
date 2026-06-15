variable "name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "app_gateways" {
  type = map(object({
    hostname = string
  }))
}

variable "tags" {
  type = map(string)
}
