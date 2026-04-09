locals {
  region = "eu-central-1"
  domains = [
    "imon.work",
    "imon.academy"
  ]
  oidc_url = replace(aws_eks_cluster.main.identity[0].oidc[0].issuer, "https://", "")
}
