locals {

  common_tags = {

    Environment = var.environment

    ManagedBy = "Terraform"

    Platform = "AKS"

    Project = "MultiRegion-SaaS"
  }
}
