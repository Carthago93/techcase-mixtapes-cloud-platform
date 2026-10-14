locals {
  name = "${var.name_prefix}-${var.environment}"
  tags = merge(var.common_tags, {
    Project     = "Mixtapes"
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.13"

  name = local.name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  public_subnets  = var.public_subnet_cidrs
  private_subnets = var.private_subnet_cidrs

  enable_nat_gateway     = true
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.single_nat_gateway ? false : true

  enable_dns_hostnames = true
  enable_dns_support   = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  tags = local.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  cluster_endpoint_public_access  = var.enable_cluster_public_access
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access_cidrs = var.enable_cluster_public_access ? var.cluster_public_access_cidrs : null

  enable_cluster_creator_admin_permissions = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    default = {
      name           = "${var.cluster_name}-workers"
      instance_types = var.instance_types
      capacity_type  = "ON_DEMAND"

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size

      labels = {
        workload = "general"
      }
    }
  }

  tags = local.tags
}

resource "aws_ecr_repository" "api" {
  name                 = "${local.name}/php-api"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = false

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = local.tags
}

resource "aws_cloudwatch_log_group" "application" {
  name              = "/mixtapes/${var.environment}/application"
  retention_in_days = 30
  tags              = local.tags
}

resource "aws_sqs_queue" "transcoding_dlq" {
  name                      = "${local.name}-transcoding-dlq"
  message_retention_seconds = 1209600
  sqs_managed_sse_enabled   = true
  tags                      = local.tags
}

resource "aws_sqs_queue" "transcoding" {
  name                       = "${local.name}-transcoding"
  visibility_timeout_seconds = 900
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 20
  sqs_managed_sse_enabled    = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.transcoding_dlq.arn
    maxReceiveCount     = 5
  })

  tags = local.tags
}
