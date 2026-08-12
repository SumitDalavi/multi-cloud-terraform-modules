module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_endpoint_public_access  = var.enable_public_access
  cluster_endpoint_private_access = true

  # Encryption at rest for secrets (secure by default)
  cluster_encryption_config = {
    resources = ["secrets"]
  }

  eks_managed_node_groups = {
    default = {
      instance_types = var.node_instance_types
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size
    }
  }

  tags = merge(var.tags, {
    ManagedBy = "terraform-module-registry"
  })
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_certificate_authority" {
  value = module.eks.cluster_certificate_authority_data
}
