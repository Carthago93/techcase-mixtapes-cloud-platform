resource "aws_security_group" "database" {
  count       = var.enable_database ? 1 : 0
  name        = "${local.name}-database"
  description = "Database ingress from EKS node security group only"
  vpc_id      = module.vpc.vpc_id
  tags        = local.tags
}

resource "aws_vpc_security_group_ingress_rule" "database_from_nodes" {
  count                        = var.enable_database ? 1 : 0
  security_group_id            = aws_security_group.database[0].id
  referenced_security_group_id  = module.eks.node_security_group_id
  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  description                  = "MySQL protocol from EKS nodes"
}

resource "aws_db_subnet_group" "database" {
  count      = var.enable_database ? 1 : 0
  name       = "${local.name}-db"
  subnet_ids = module.vpc.private_subnets
  tags       = local.tags
}

resource "aws_rds_cluster" "database" {
  count                   = var.enable_database ? 1 : 0
  cluster_identifier      = "${local.name}-aurora"
  engine                  = "aurora-mysql"
  database_name           = var.db_name
  master_username         = var.db_username
  master_password         = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.database[0].name
  vpc_security_group_ids  = [aws_security_group.database[0].id]
  storage_encrypted       = true
  kms_key_id              = aws_kms_key.audio.arn
  backup_retention_period = 7
  deletion_protection     = var.enable_deletion_protection
  skip_final_snapshot     = !var.enable_deletion_protection
  apply_immediately       = false

  lifecycle {
    precondition {
      condition     = var.db_password != null && length(var.db_password) >= 16
      error_message = "When enable_database=true, set db_password to a strong password of at least 16 characters."
    }
  }

  tags = local.tags
}

resource "aws_rds_cluster_instance" "database" {
  count              = var.enable_database ? 2 : 0
  identifier         = "${local.name}-db-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.database[0].id
  instance_class     = var.db_instance_class
  engine             = aws_rds_cluster.database[0].engine
  db_subnet_group_name = aws_db_subnet_group.database[0].name
  publicly_accessible  = false
  tags                 = local.tags
}
