resource "aws_kms_key" "main" {
  description                        = "Centralized symmetric key for Control Tower 5.0 Backups"
  is_enabled                         = true
  enable_key_rotation                = true
  multi_region                       = true
  bypass_policy_lockout_safety_check = false
  deletion_window_in_days            = 30
}

resource "aws_kms_key_policy" "main" {
  key_id = aws_kms_key.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Root access
      {
        Sid    = "EnableRoot"
        Effect = "Allow"
        Principal = {
          AWS = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root", "${data.aws_iam_role.sso_admin.arn}"]
        }
        Action   = "kms:*"
        Resource = "*"
      },

      # AWS Backup service
      {
        Sid    = "AllowAWSBackup"
        Effect = "Allow"
        Principal = {
          Service = [
            "backup.amazonaws.com",
            "backup-storage.amazonaws.com"
          ]
        }
        Action = [
          "kms:Decrypt",
          "kms:DescribeKey",
          "kms:GenerateDataKey*",
          "kms:CreateGrant",
          "kms:ListGrants"
        ]
        Resource = "*"
      },

      # Control Tower + StackSet execution roles
      {
        Sid    = "AllowControlTowerExecution"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey",
          "kms:CreateGrant"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "aws:PrincipalOrgID" = data.aws_organizations_organization.current.id
          }
        }
      }
    ]
  })
}

resource "aws_kms_alias" "main" {
  name          = "alias/control-tower-backup-key"
  target_key_id = aws_kms_key.main.key_id
}

# --------- Replicas ---------

# resource "aws_kms_replica_key" "replicas" {
#   for_each = local.kms_replica_regions

#   region                  = each.value
#   primary_key_arn         = aws_kms_key.main.arn
#   description             = "Replica for ${each.value}"
#   deletion_window_in_days = 7

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [

#       {
#         Sid    = "EnableRoot"
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
#         }
#         Action   = "kms:*"
#         Resource = "*"
#       },

#       {
#         Sid    = "AllowAWSBackup"
#         Effect = "Allow"
#         Principal = {
#           Service = [
#             "backup.amazonaws.com",
#             "backup-storage.amazonaws.com"
#           ]
#         }
#         Action = [
#           "kms:Decrypt",
#           "kms:DescribeKey",
#           "kms:GenerateDataKey*",
#           "kms:CreateGrant",
#           "kms:ListGrants"
#         ]
#         Resource = "*"
#       },

#       {
#         Sid    = "AllowOrg"
#         Effect = "Allow"
#         Principal = {
#           AWS = "*"
#         }
#         Action = [
#           "kms:Encrypt",
#           "kms:Decrypt",
#           "kms:ReEncrypt*",
#           "kms:GenerateDataKey*",
#           "kms:DescribeKey",
#           "kms:CreateGrant"
#         ]
#         Resource = "*"
#         Condition = {
#           StringEquals = {
#             "aws:PrincipalOrgID" = data.aws_organizations_organization.current.id
#           }
#         }
#       }
#     ]
#   })
# }

# resource "aws_kms_alias" "replica_aliases" {
#   for_each = local.kms_replica_regions

#   region        = each.value
#   name          = "alias/control-tower-backup-key"
#   target_key_id = aws_kms_replica_key.replicas[each.key].key_id
# }
