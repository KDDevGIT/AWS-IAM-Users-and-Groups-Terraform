provider "aws" {
    region = var.aws_region
    profile = var.aws_profile
}

# Password Policy
resource "aws_iam_account_password_policy" "this" {
  minimum_password_length = var.password_policy.minimum_password_length
  require_lowercase_characters = var.password_policy.require_lowercase_characters
  require_uppercase_characters = var.password_policy.require_uppercase_characters
  require_numbers = var.password_policy.require_numbers
  require_symbols = var.password_policy.require_symbols
  allow_users_to_change_password = var.password_policy.allow_users_to_change_password
  hard_expiry = var.password_policy.hard_expiry
  max_password_age = var.password_policy.max_password_age
  password_reuse_prevention = var.password_policy.password_reuse_prevention
}

# Users (no password)
resource "aws_iam_user" "users" {
  for_each = var.users
  name = each.key
  tags = var.tags
}

# Custom Managed Policies
resource "aws_iam_policy" "custom" {
  for_each = var.managed_policies
  name = each.key
  description = lookup(each.value, "description",null)
  policy = each.value.policy_json
  tags = var.tags
}

# Groups
resource "aws_iam_group" "groups" {
  for_each = var.groups
  name = each.key
}

# Attach AWS Managed/Custom Policies to Groups
resource "aws_iam_group_policy_attachment" "aws_managed_attach" {
  for_each = {
     for g, cfg in var.groups :
     "${g}-aws" => {
        group = g 
        policies = [for p in lookup(cfg,"attached_policies",[]) : p if startswith(p,"aws:")]
     }
  }

  group = aws_iam_group.groups[each.value.group].name
  policy_arn = local.aws_managed[element(each.value.policies,0)]
}

# Custom Policy Attachment
resource "aws_iam_group_policy_attachment" "custom_attach" {
  for_each = {
    for g, cfg in var.groups :
    g => [for p in lookup(cfg,"attached_policies",[]) : p if !startswith(p,"aws:")]
  }
  group = aws_iam_group.groups[each.key].name 
  policy_arn = aws_iam_policy.custom[each.value[0]].arn 
}

# Group Membership
resource "aws_iam_user_group_membership" "membership" {
  for_each = var.group_membership
  user = aws_iam_user.users[each.value[0]].name
  groups = [aws_iam_group.groups[each.key].name]
}

# MFA Enforcement
data "aws_iam_policy_document" "deny_without_mfa" {
  statement {
    sid = "DenyAllIfNoMFA"
    effect = "Deny"
    actions = ["*"]
    resources = ["*"]
    condition {
      test = "BoolIfExists"
      variable = "aws:MultiFactorAuthPresent"
      values = ["false"]
    }
  }
}

# Global MFA Enforcement
resource "aws_iam_policy" "deny_without_mfa" {
  count = var.enforce_mfa_policy ? 1 : 0
  name = "DenyAllIfNoMFA"
  policy = data.aws_iam_policy_document.deny_without_mfa.json
  tags = var.tags
}

# Attach MFA Enforcement to all users
resource "aws_iam_user_policy_attachment" "mfa_enforce_attach" {
  for_each = var.enforce_mfa_policy ? var.users : {}
  user = aws_iam_user.users[each.key].name
  policy_arn = aws_iam_policy.deny_without_mfa[0].arn
}