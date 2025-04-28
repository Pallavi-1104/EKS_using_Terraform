provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source      = "./modules/vpc"
  cidr_block  = var.vpc_cidr_block
}

module "eks" {
  source      = "./modules/eks"
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.subnet_ids
  cluster_name = var.cluster_name
}

# The data blocks should be used after the EKS cluster is created
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks]  # Ensure that the EKS cluster is created first
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_name
  depends_on = [module.eks]  # Ensure that the EKS cluster is created first
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "monitoring" {
  source       = "./modules/monitoring"
  cluster_name = module.eks.cluster_name
}

module "app" {
  source       = "./modules/app"
  cluster_name = module.eks.cluster_name
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.subnet_ids
}
