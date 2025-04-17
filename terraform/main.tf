# main.tf
terraform {
    required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.75.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.11.0"
    }
  }
  required_version = ">= 0.14"
} 


data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "aws" {
  region = "ap-northeast-2"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.19.0"

  name = "one-cluster-vpc"
  cidr = "192.168.0.0/16"

  azs             = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
  public_subnets  = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  private_subnets = ["192.168.4.0/24", "192.168.5.0/24", "192.168.6.0/24"]

  enable_nat_gateway   = true
  single_nat_gateway   = true

  public_subnet_tags = {
      "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
}

module "eks" {
  source = "terraform-aws-modules/eks/aws"
  version = "17.24.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.32"
  


  vpc_id          = module.vpc.vpc_id
  subnets         = module.vpc.public_subnets

  enable_irsa     = true
  manage_aws_auth = true

  cluster_endpoint_public_access = true

  node_groups = {
    default = {
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 1
      instance_types    = ["t3.xlarge"]

      subnets = module.vpc.public_subnets

      iam_role_additional_policies = {
        ecr_read = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        eks_service = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
      }
    }
  }
}
data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}