# ROOT
module "iam_baseline" {
  source = "./modules/iam_baseline"

  account_alias = var.account_alias
  password_policy = var.password_policy
  users = var.users
  groups = var.groups
  managed_policies = var.managed_policies
  group_membership = var.group_membership
  enforce_mfa_policy = var.enforce_mfa_policy
  tags = var.tags
}