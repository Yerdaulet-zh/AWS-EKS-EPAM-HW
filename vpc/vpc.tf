resource "aws_vpc" "vpc" {
  cidr_block           = local.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Project = "${local.project_name}"
  }
}
