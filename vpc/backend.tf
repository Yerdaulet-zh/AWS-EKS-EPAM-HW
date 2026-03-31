terraform {
  backend "s3" {
    bucket       = "shapagat-medeu-terraform-states"
    key          = "shapagat-admin/control-tower/terraform.tfstate"
    region       = "eu-central-1"
    encrypt      = true
    use_lockfile = true
    profile      = "second"
  }
}
