resource "aws_security_group" "redis" {
  count       = var.enable_redis ? 1 : 0
  name        = "${local.name}-redis"
  description = "Redis ingress from EKS node security group only"
  vpc_id      = module.vpc.vpc_id
  tags        = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "redis_from_nodes" {
  count                       = var.enable_redis ? 1 : 0
  security_group_id           = aws_security_group.redis[0].id
  referenced_security_group_id = module.eks.node_security_group_id
  ip_protocol                 = "tcp"
  from_port                   = 6379
  to_port                     = 6379
  description                 = "Redis from EKS nodes"
}

resource "aws_elasticache_subnet_group" "redis" {
  count      = var.enable_redis ? 1 : 0
  name       = "${local.name}-redis"
  subnet_ids = module.vpc.private_subnets
}

resource "aws_elasticache_replication_group" "redis" {
  count                      = var.enable_redis ? 1 : 0
  replication_group_id       = "${var.name_prefix}-${var.environment}"
  description                = "Mixtapes Redis-compatible cache"
  engine                     = "redis"
  node_type                  = var.redis_node_type
  num_cache_clusters         = var.redis_num_cache_clusters
  automatic_failover_enabled = var.redis_num_cache_clusters >= 2
  multi_az_enabled           = var.redis_num_cache_clusters >= 2
  subnet_group_name          = aws_elasticache_subnet_group.redis[0].name
  security_group_ids         = [aws_security_group.redis[0].id]
  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  port                       = 6379
  apply_immediately          = false
  tags                       = local.tags
}
