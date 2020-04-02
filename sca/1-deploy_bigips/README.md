# Steps
## Obtain state from 0-core
```bash
terraform output -state=../0-core/terraform.tfstate --json > core.auto.tfvars.json
```
## Initialize Terraform
```bash
terraform init
```
## Validate and Apply
```bash
terraform validate && terraform apply
```