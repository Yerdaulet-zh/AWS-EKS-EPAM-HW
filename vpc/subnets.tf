resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.public_subnet_public_cidr
  availability_zone       = "${local.region}a"
  map_public_ip_on_launch = true

  tags = {
    Project = "${local.project_name}"
    Name    = "Public Subent"
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.private_subnet_public_cidr
  availability_zone       = "${local.region}b"
  map_public_ip_on_launch = false

  tags = {
    Project = "${local.project_name}"
    Name    = "Private Subent"
  }
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}

output "private_subnet_id" {
  value = aws_subnet.private.id
}
