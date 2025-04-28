output "cluster_name" {
  description = "EKS Cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS Cluster API endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_arn" {
  description = "EKS Cluster ARN"
  value       = module.eks.cluster_arn
}
