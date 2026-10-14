output "vpc_id" {
  description = "VPC ID."
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = module.vpc.private_subnets
}

output "cluster_name" {
  description = "EKS cluster name."
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS API endpoint."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "EKS cluster security group ID."
  value       = module.eks.cluster_security_group_id
}

output "node_security_group_id" {
  description = "EKS node security group ID."
  value       = module.eks.node_security_group_id
}

output "ecr_repository_url" {
  description = "Container registry URL for the PHP API image."
  value       = aws_ecr_repository.api.repository_url
}

output "audio_bucket_name" {
  description = "Private S3 bucket name for audio assets."
  value       = aws_s3_bucket.audio.bucket
}

output "audio_cloudfront_domain_name" {
  description = "CloudFront domain serving audio. Signed URL/key-group configuration is still required for authorization."
  value       = aws_cloudfront_distribution.audio.domain_name
}

output "transcoding_queue_url" {
  value       = aws_sqs_queue.transcoding.url
  description = "SQS queue URL for audio conversion jobs."
}

output "application_iam_policy_arn" {
  value       = aws_iam_policy.application_audio_and_queue.arn
  description = "Attach to a dedicated EKS workload identity, not the node role."
}

output "database_writer_endpoint" {
  description = "Aurora writer endpoint; null when database is disabled."
  value       = var.enable_database ? aws_rds_cluster.database[0].endpoint : null
}

output "redis_primary_endpoint" {
  description = "Redis primary endpoint; null when Redis is disabled."
  value       = var.enable_redis ? aws_elasticache_replication_group.redis[0].primary_endpoint_address : null
}
