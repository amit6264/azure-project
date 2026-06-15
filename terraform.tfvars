github_org  = "amit-patidar"
github_repo = "azure-project"


environment = "prod"

regions = {

  eu = {

    location = "westeurope"

    vnet_cidr = "10.0.0.0/16"

    aks_subnet_cidr = "10.0.1.0/24"

    pe_subnet_cidr = "10.0.2.0/24"

    firewall_subnet_cidr = "10.0.3.0/24"

    appgw_subnet_cidr = "10.0.4.0/24"
  }

  asia = {

    location = "eastasia"

    vnet_cidr = "10.1.0.0/16"

    aks_subnet_cidr = "10.1.1.0/24"

    pe_subnet_cidr = "10.1.2.0/24"

    firewall_subnet_cidr = "10.1.3.0/24"

    appgw_subnet_cidr = "10.1.4.0/24"
  }

  me = {

    location = "uaenorth"

    vnet_cidr = "10.2.0.0/16"

    aks_subnet_cidr = "10.2.1.0/24"

    pe_subnet_cidr = "10.2.2.0/24"

    firewall_subnet_cidr = "10.2.3.0/24"

    appgw_subnet_cidr = "10.2.4.0/24"
  }
}


