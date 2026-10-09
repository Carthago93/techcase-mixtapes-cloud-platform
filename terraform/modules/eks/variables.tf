variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "Supported Kubernetes version for the cluster"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the EKS cluster"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for EKS and worker nodes"
  type        = list(string)
}

variable "instance_types" {
  description = "EC2 instance types for worker nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "min_size" {
  description = "Minimum worker node count"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum worker node count"
  type        = number
  default     = 4
}

variable "desired_size" {
  description = "Desired worker node count"
  type        = number
  default     = 2
}
