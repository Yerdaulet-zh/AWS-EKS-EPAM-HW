terraform {
  backend "s3" {
    bucket       = "shapagat-medeu-terraform-states"
    key          = "second/eks-epam-hw-eks/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
    profile      = "895587011312_AdministratorAccess"
  }
}
