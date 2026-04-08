# resource "aws_eip" "nat_eip" {
#   tags = {
#     Project = "${local.project_name}"
#     Name    = "NAT EIP"
#   }
# }

# resource "aws_nat_gateway" "nat_gateway" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_1a.id

#   tags = {
#     Project = "${local.project_name}"
#     Name    = "NAT Gateway"
#   }
# }
