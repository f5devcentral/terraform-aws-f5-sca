# Loop Demo

## Deployment Steps
### Obtain state from core and security_stack
```bash
terraform output -state=../core/terraform.tfstate --json > core.auto.tfvars.json
terraform output -state=../security_stack/terraform.tfstate --json > security.auto.tfvars.json
```
### Initialize Terraform
```bash
terraform init
```
### Validate and Apply
```bash
terraform validate && terraform apply
```