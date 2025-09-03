# AWS IAM-Users and Group Management using Terraform
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

## Prerequisites
- [Terraform](https://developer.hashicorp.com/terraform/downloads) >= 1.6  
- [AWS CLI](https://docs.aws.amazon.com/cli/) v2  
- AWS account with a **bootstrap admin user** (not root)  
- S3 bucket & DynamoDB table for state (create once manually):

```bash
aws s3api create-bucket --bucket tf-state-youracct-dev --region us-east-1
aws dynamodb create-table \
  --table-name tf-lock-youracct-dev \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST
```
