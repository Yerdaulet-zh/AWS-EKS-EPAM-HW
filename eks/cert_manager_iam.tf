resource "aws_iam_policy" "cert_manager_route53" {
  name        = "cert-manager-route53-policy"
  description = "Permissions for cert-manager to solve DNS-01 challenges via Route53"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "route53:GetChange"
        Resource = "arn:aws:route53:::change/*"
      },
      {
        Effect = "Allow"
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListResourceRecordSets"
        ]
        Resource = [for zone in data.aws_route53_zone.zones : zone.arn]
      },
      {
        Effect   = "Allow"
        Action   = "route53:ListHostedZonesByName"
        Resource = "*"
      }
    ]
  })
}

module "cert_manager_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.0"

  role_name = "cert-manager-route53-role"

  oidc_providers = {
    main = {
      provider_arn               = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.oidc_url}"
      namespace_service_accounts = ["cert-manager:cert-manager"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "cert_manager_attach" {
  role       = module.cert_manager_irsa_role.iam_role_name
  policy_arn = aws_iam_policy.cert_manager_route53.arn
}

output "cert_manager_iam_role_arn" {
  value = module.cert_manager_irsa_role.iam_role_arn
}
