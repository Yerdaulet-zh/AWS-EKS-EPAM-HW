locals {
  region               = "eu-central-1"
  project_name         = "epam-eks-hw"
  vpc_cidr_block       = "10.0.0.0/16"
  public_subnet_cidr1  = "10.0.5.0/24"
  public_subnet_cidr2  = "10.0.6.0/24"
  private_subnet_cidr1 = "10.0.7.0/24"
  private_subnet_cidr2 = "10.0.8.0/24"
}
