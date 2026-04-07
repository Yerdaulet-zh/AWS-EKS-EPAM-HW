output "vpc_id" {
  description = "VPC ID for the EKS cluster"
  value       = aws_vpc.vpc.id
}

output "public_subnets" {
  description = "Map of public subnet IDs"
  value = {
    "public_1a" = aws_subnet.public_1a.id
    "public_2b" = aws_subnet.public_2b.id
  }
}

output "private_subnets" {
  description = "Map of private subnet IDs"
  value = {
    "private_1a" = aws_subnet.private_1a.id
    "private_2b" = aws_subnet.private_2b.id
  }
}

output "all_subnets" {
  description = "Map of all subnet IDs (for cluster control plane)"
  value = {
    "public_1a"  = aws_subnet.public_1a.id
    "public_2b"  = aws_subnet.public_2b.id
    "private_1a" = aws_subnet.private_1a.id
    "private_2b" = aws_subnet.private_2b.id
  }
}
