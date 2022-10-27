module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  node_security_group_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = null
  }

  cluster_name    = local.cluster_name
  cluster_version = "1.22"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

    attach_cluster_primary_security_group = true

    # Disabling and using externally provided security groups
    create_security_group = false
  }

  eks_managed_node_groups = {
    one = {
      name = "node-group-1"

      instance_types = ["t3.small"]

      min_size     = 1
      max_size     = 1
      desired_size = 1

      vpc_security_group_ids = [
        aws_security_group.node_group_one.id
      ]
    }
  }
}

#https://docs.aws.amazon.com/eks/latest/userguide/calico.html

