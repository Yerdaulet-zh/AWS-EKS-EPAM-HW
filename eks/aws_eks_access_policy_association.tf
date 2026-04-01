resource "aws_eks_access_policy_association" "admin" {
  cluster_name  = aws_eks_cluster.main.name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  principal_arn = data.aws_iam_role.sso_admin.arn

  access_scope {
    type = "cluster"
  }

  lifecycle {
    prevent_destroy = true
  }
}
