terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.15.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "= 2.6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }
  }

  required_version = "~> 1.2.0"
}

