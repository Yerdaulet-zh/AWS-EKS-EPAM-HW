data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_organizations_organization" "current" {}

data "aws_iam_role" "sso_admin" {
  name = "AWSReservedSSO_AdministratorAccess_3586681a9dcf4676"
}
