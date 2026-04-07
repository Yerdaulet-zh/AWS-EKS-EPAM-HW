data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "epam-terrform-state-bucket"
    key     = "eks-epam-hw/vpc/terraform.tfstate"
    region  = "eu-central-1"
    profile = "895587011312_AdministratorAccess"
  }
}
