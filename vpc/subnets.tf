resource "aws_subnet" "public_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.public_subnet_cidr1
  availability_zone       = "${local.region}a"
  map_public_ip_on_launch = true

  tags = {
    Project = "${local.project_name}"
    Name    = "Public Subnet 1"
  }
}

resource "aws_subnet" "public_2b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.public_subnet_cidr2
  availability_zone       = "${local.region}b"
  map_public_ip_on_launch = true

  tags = {
    Project = "${local.project_name}"
    Name    = "Public Subnet 2"
  }
}

resource "aws_subnet" "private_1a" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.private_subnet_cidr1
  availability_zone       = "${local.region}a"
  map_public_ip_on_launch = false

  tags = {
    Project = "${local.project_name}"
    Name    = "Private Subnet 1"
  }
}

resource "aws_subnet" "private_2b" {
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = local.private_subnet_cidr2
  availability_zone       = "${local.region}b"
  map_public_ip_on_launch = false

  tags = {
    Project = "${local.project_name}"
    Name    = "Private Subnet 2"
  }
}

output "public_subnet_id_1" {
  value = aws_subnet.public_1a.id
}

output "public_subnet_id_2" {
  value = aws_subnet.public_2b.id
}

output "private_subnet_id_1" {
  value = aws_subnet.private_1a.id
}

output "private_subnet_id_2" {
  value = aws_subnet.private_2b.id
}
