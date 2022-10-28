provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "aws" {
  region = var.region
  token = var.aws_session_token
}

data "aws_availability_zones" "available" {}

locals {
  cluster_name = "eks-reach"
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

terraform {
  backend "s3" {
    bucket         = "reach-tf-state"
    key            = "global/s3/terraform.tfstate"
    region         = "eu-west-2"
  }
}