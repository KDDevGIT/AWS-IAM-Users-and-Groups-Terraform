# AWS IAM Users and Group Management using Terraform
Infrastructure as Code for IAM User &amp; Group Management. This repository contains Terraform configurations to manage AWS IAM users, groups, policies, and MFA enforcement. It demonstrates best practices in least-privilege access, remote state management, and account baseline setup.

Uses **Terraform** to manage AWS IAM identities — creating **users, groups, and policies** — while applying **secure defaults** such as MFA enforcement and strong password policies.

---

## Features
- **Remote State** stored in S3 with DynamoDB locking  
- **Account Alias** for cleaner AWS console URLs  
- **Password Policy** enforcing complexity & rotation  
- **IAM Users & Groups** defined declaratively  
- **AWS-Managed & Custom Policies** for flexible access control  
- **MFA Enforcement** via deny-all-unless-MFA policy  
- **Modular Design** to support multiple environments (`dev`, `stage`, `prod`)  

---

# Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.6  
- [AWS CLI](https://docs.aws.amazon.com/cli/) v2  
- AWS account with a **bootstrap admin user** (not root)  
- S3 bucket & DynamoDB table for state (create once manually):

```bash
aws s3api create-bucket \
--bucket iam-users-and-groups \
--region us-west-1 \
--create-bucket-configuration LocationConstraint=us-west-1

aws dynamodb create-table \
--table-name iam-uag-table \
--attribute-definitions AttributeName=LockID,AttributeType=S \
--key-schema AttributeName=LockID,KeyType=HASH \
--billing-mode PAY_PER_REQUEST \
--region us-west-1 
```

# Setup and Usage 
## Example backend in .hcl
```bash
bucket = "iam_users_and_groups"
key = "iam/terraform.tfstate"
region = "us-west-1"
dynamodb_table = "iam-uag-table"
encrypt = true
```
# Example Configuration (TFVARS)
## Header
```bash
aws_region = "us-west-1"
aws_profile = "bootstrap_admin"
account_alias = "bucket-dev"
```
## Define Password Policy
```bash
password_policy = {
    minimum_password_length = <NUMBER>
    require_lowercase_characters = true/false
    require_uppercase_characters = true/false
    require_numbers = true/false
    require_symbols = true/false
    allow_users_to_change_password = true/false
    hard_expiry = true/false
    max_password_age = <NUMBER>
    password_reuse_prevention = <NUMBER>
}
```
## Define Users
```bash 
users = {
    "USER" = { # Name 
        pgp_key = null
    }
}
```
## Define Groups
```bash
groups = {
    "ROLE" = {
        attached_policies = ["aws:<AWS_GROUP_NAME>"]
    }
}
```
## Custom Managed Policies
```bash
managed_policies = {
    "POLICY" = {
        description = "Allow viewing billing info"
        policy_json = jsonencode({
            Version = "2012-10-17"
            Statement = [{
                Effect = "Allow"
                Action = [""]
                Resource = "*"
            }]
        })
    }
}
```
## Group Membership
```bash 
group_membership = {
    "ROLE" = ["USER"]
}
```
## Toggle Global MFA Policy
```bash
enforce_mfa_policy = true/false
```
## Tags
```bash
tags = {
    project = "iam_baseline"
    env = "dev"
}
```
## Intialize Terraform
```bash
cd iam-baseline
terraform init -backend-config=envs/dev/backend.hcl
```

## Run
```bash
terraform plan -var-file=envs/dev/terraform.tfvars
terraform apply -var-file=envs/dev/terraform.tfvars
```

## Example Output
```bash
https://youracct-dev.signin.aws.amazon.com/console
```

