resource "aws_network_acl" "acl" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Project = "${local.project_name}"
  }
}

resource "aws_network_acl_rule" "acl_rule_ingress" {
  network_acl_id = aws_network_acl.acl.id
  rule_number    = 100
  egress         = false
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_rule" "acl_rule_egress" {
  network_acl_id = aws_network_acl.acl.id
  rule_number    = 100
  egress         = true
  protocol       = "tcp"
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  network_acl_id = aws_network_acl.acl.id
}

resource "aws_network_acl_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  network_acl_id = aws_network_acl.acl.id
}

# resource "aws_network_acl_association" "private" {
#   subnet_id      = aws_subnet.private.id
#   network_acl_id = aws_network_acl.acl.id
# }
