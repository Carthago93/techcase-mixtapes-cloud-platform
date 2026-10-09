module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  endpoint_public_access  = false
  endpoint_private_access = true

  enable_cluster_creator_admin_permissions = false

  eks_managed_node_groups = {
    default = {
      name = "${var.cluster_name}-workers"

      instance_types = var.instance_types
      capacity_type  = "ON_DEMAND"

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size
    }
  }

  tags = {
    Project     = "Mixtapes"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
