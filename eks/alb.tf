# # Fetch the official AWS IAM Policy for the LB Controller
# data "http" "iam_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/main/docs/install/iam_policy.json"
# }

# resource "aws_iam_policy" "lb_controller_policy" {
#   name        = "${var.cluster_name}-lb-controller-policy"
#   description = "Permissions for EKS Load Balancer Controller"
#   policy      = data.http.iam_policy.response_body
# }

# # Create the IAM Role with Trust Relationship for EKS OIDC
# data "aws_iam_policy_document" "lb_controller_trust" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(aws_iam_openid_connect_provider.oidc_provider.url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
#     }

#     principals {
#       identifiers = [aws_iam_openid_connect_provider.oidc_provider.arn]
#       type        = "Federated"
#     }
#   }
# }

# resource "aws_iam_role" "lb_controller_role" {
#   name               = "${var.cluster_name}-lb-controller-role"
#   assume_role_policy = data.aws_iam_policy_document.lb_controller_trust.json
# }

# resource "aws_iam_role_policy_attachment" "lb_controller_attach" {
#   policy_arn = aws_iam_policy.lb_controller_policy.arn
#   role       = aws_iam_role.lb_controller_role.name
# }

# Install the Controller using Helm
# resource "helm_release" "aws_lb_controller" {
#   name       = "aws-load-balancer-controller"
#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"

#   set {
#     name  = "clusterName"
#     value = aws_eks_cluster.main.name
#   }

#   set {
#     name  = "serviceAccount.create"
#     value = "true"
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.lb_controller_role.arn
#   }

#   set {
#     name  = "vpcId"
#     value = var.vpc_id
#   }

#   set {
#     name  = "region"
#     value = local.region
#   }
# }
