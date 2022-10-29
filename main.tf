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



provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.cluster.name]
      command     = "aws"
    }
  }
}



resource "helm_release" "ingress-nginx" {
  name       = "ingress"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"
  namespace  = "ingress-nginx"
  version    = "9.1.10"
}


# resource "aws_secretsmanager_secret" "reach" {
#   name = "reach"
# }

# resource "aws_secretsmanager_secret_version" "reach_licence" {
#   secret_id     = aws_secretsmanager_secret.reach.id
#   secret_string = <<EOF
#    {
#     "reach_licence_key": "key",
#     "reach_licence_signature": "signature",
#     "acr_username": "username",
#     "acr_password": "password"
#    }
# EOF
# }