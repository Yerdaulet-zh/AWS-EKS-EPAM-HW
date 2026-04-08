resource "aws_network_acl" "acl" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Project = "${local.project_name}"
  }
}

resource "aws_network_acl_rule" "acl_rule_ingress" {
  for_each = {
    "100" = "tcp"
    "110" = "udp"
  }

  network_acl_id = aws_network_acl.acl.id
  rule_number    = each.key
  egress         = false
  protocol       = each.value
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_rule" "acl_rule_egress" {
  for_each = {
    "100" = "tcp"
    "110" = "udp"
  }

  network_acl_id = aws_network_acl.acl.id
  rule_number    = each.key
  egress         = true
  protocol       = each.value
  cidr_block     = "0.0.0.0/0"
  rule_action    = "allow"
  from_port      = 0
  to_port        = 65535
}

resource "aws_network_acl_association" "public_1" {
  subnet_id      = aws_subnet.public_1a.id
  network_acl_id = aws_network_acl.acl.id
}

resource "aws_network_acl_association" "public_2" {
  subnet_id      = aws_subnet.public_2b.id
  network_acl_id = aws_network_acl.acl.id
}

resource "aws_network_acl_association" "private_1" {
  subnet_id      = aws_subnet.private_1a.id
  network_acl_id = aws_network_acl.acl.id
}

resource "aws_network_acl_association" "private_2" {
  subnet_id      = aws_subnet.private_2b.id
  network_acl_id = aws_network_acl.acl.id
}
