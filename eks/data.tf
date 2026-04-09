data "aws_caller_identity" "current" {}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "epam-terrform-state-bucket"
    key     = "eks-epam-hw/vpc/terraform.tfstate"
    region  = "eu-central-1"
    profile = "895587011312_AdministratorAccess"
  }
}

# Fetch the NVIDIA-optimized AMI version
data "aws_ssm_parameter" "eks_ami_nvidia_amazon_linux_2023" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.main.version}/amazon-linux-2023/x86_64/nvidia/recommended/release_version"
}

# General-purpose EKS-optimized AMI
data "aws_ssm_parameter" "eks_ami_amazon_linux_2023" {
  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.main.version}/amazon-linux-2023/arm64/standard/recommended/release_version"
}

data "aws_route53_zone" "zones" {
  for_each = toset(local.domains)
  name     = each.value
}
