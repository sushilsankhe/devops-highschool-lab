provider "aws" {
  region = "us-east-1"
}

resource "aws_ecr_repository" "app" {
  name         = "devops-hs-app"
  force_delete = true
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  cidr    = "10.0.0.0/16"
  azs     = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "devops-hs-eks"
  cluster_version = "1.29"
  subnet_ids      = module.vpc.private_subnets
  vpc_id          = module.vpc.vpc_id

  eks_managed_node_groups = {
    default = {
      desired_size = 1
      instance_types = ["t3.medium"]
    }
  }
}

output "ecr_url" {
  value = aws_ecr_repository.app.repository_url
}
