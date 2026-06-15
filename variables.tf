variable "environment" {
  type = string
}

variable "regions" {

  type = map(object({

    location = string

    vnet_cidr = string

    aks_subnet_cidr = string

    pe_subnet_cidr = string

    firewall_subnet_cidr = string

    appgw_subnet_cidr = string

  }))
}



variable "github_org" {
  type = string
}

variable "github_repo" {
  type = string
}
