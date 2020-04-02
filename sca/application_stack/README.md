# Application Stack Deployment
This stack deploys the EC2 based applications.  

## Deployment Steps
### Obtain state from 0-core and security stack
```bash
terraform output -state=../core/terraform.tfstate --json > core.auto.tfvars.json
terraform output -state=../core/terraform.tfstate --json > security.auto.tfvars.json
```
### Initialize Terraform
```bash
terraform init
```
### Validate and Apply
```bash
terraform validate && terraform apply
```