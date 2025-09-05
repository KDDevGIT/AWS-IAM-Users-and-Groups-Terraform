# MODULE
output "console_login_url" {
  value = "https://${aws_iam_account_alias.this.account_alias}.signin.aws.amazon.com/console"
}