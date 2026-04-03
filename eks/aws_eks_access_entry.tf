data "aws_iam_role" "sso_admin" {
  name = "AWSReservedSSO_AdministratorAccess_3586681a9dcf4676"
}

resource "aws_eks_access_entry" "admin_access" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = data.aws_iam_role.sso_admin.arn
  type          = "STANDARD"
  lifecycle {
    prevent_destroy = false
  }
}
