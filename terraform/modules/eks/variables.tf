variable "aws_region" {
  description = "Primary AWS region for the Mixtapes workload."
  type        = string
  default     = "eu-west-1"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "name_prefix" {
  description = "Short prefix used in resource names."
  type        = string
  default     = "mixtapes"
}

variable "vpc_cidr" {
  description = "VPC CIDR; choose a range that does not overlap connected networks."
  type        = string
  default     = "10.40.0.0/16"
}

variable "availability_zones" {
  description = "Availability zones. Use three AZs for production resilience."
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}

variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.40.0.0/20", "10.40.16.0/20", "10.40.32.0/20"]
}

variable "private_subnet_cidrs" {
  type    = list(string)
  default = ["10.40.48.0/20", "10.40.64.0/20", "10.40.80.0/20"]
}

variable "single_nat_gateway" {
  description = "Use one NAT gateway to reduce non-production costs; production usually benefits from one per AZ."
  type        = bool
  default     = false
}

variable "cluster_name" {
  description = "EKS cluster name."
  type        = string
  default     = "mixtapes-dev"
}

variable "kubernetes_version" {
  description = "Kubernetes version supported by EKS in the selected region."
  type        = string
  default     = "1.32"
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "min_size" {
  type    = number
  default = 2
}

variable "max_size" {
  type    = number
  default = 4
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "enable_cluster_public_access" {
  description = "Enable public EKS API access only if required; restrict allowed CIDRs."
  type        = bool
  default     = false
}

variable "cluster_public_access_cidrs" {
  description = "Allowed CIDRs for the EKS public API endpoint if enabled."
  type        = list(string)
  default     = []
}

variable "audio_bucket_name" {
  description = "Globally unique S3 bucket name. Leave empty to use a generated suffix."
  type        = string
  default     = ""
}

variable "audio_retention_days" {
  description = "Optional transition/expiration policy for noncurrent versions. Set 0 to disable expiration."
  type        = number
  default     = 0
}

variable "enable_database" {
  description = "Create Aurora MySQL-compatible database resources."
  type        = bool
  default     = false
}

variable "db_name" {
  type    = string
  default = "mixtapes"
}

variable "db_username" {
  type      = string
  default   = "mixtapes_admin"
  sensitive = true
}

variable "db_password" {
  description = "Supply via a secrets manager or TF_VAR_db_password; do not commit it."
  type        = string
  sensitive   = true
  default     = null
}

variable "db_instance_class" {
  type    = string
  default = "db.t4g.medium"
}

variable "enable_redis" {
  description = "Create ElastiCache Redis OSS resources."
  type        = bool
  default     = false
}

variable "redis_node_type" {
  type    = string
  default = "cache.t4g.small"
}

variable "redis_num_cache_clusters" {
  description = "Number of cache nodes including primary; at least 2 for failover."
  type        = number
  default     = 2
}

variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
