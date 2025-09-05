# MODULE
locals {
  aws_managed = {
    "aws:AdministratorAccess" = "arn:aws:iam::aws:policy/AdministratorAccess"
    "aws:ReadOnlyAccess" = "arn:aws:iam::aws:policy/ReadOnlyAccess"
    "aws:PowerUserAccess" = "arn:aws:iam::aws:policy/PowerUserAccess"
  }
}

# Account Alias
resource "aws_iam_account_alias" "this" {
  account_alias = var.account_alias
}

