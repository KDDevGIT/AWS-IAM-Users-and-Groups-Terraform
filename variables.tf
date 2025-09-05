# ROOT
variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "account_alias" {
  type = string
}

variable "password_policy" {
  type = any
}

variable "users" {
  type = map(any)
}

variable "groups" {
  type = map(any)
}

variable "managed_policies" {
  type = map(any)
}

variable "group_membership" {
  type = map(list(string))
}

variable "enforce_mfa_policy" {
  type = bool
}

variable "tags" {
  type = map(string)
}

