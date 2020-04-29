# Container_Stack

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

__Overview__

This module deploys a known vulnerable web application named juicebox in a Fargate Contiainer using AWSVPC network mode.  DO NOT USE IT IN A PRODUCTION ENVIRONMENT.  DO NOT CONNECT THIS VPC TO A PRODUCTION ENVIRONMENT OR ANY ENVIRONMENT WHERE A BREACH WILL CAUSE HARM. F5 MAKES NO WARRANTIES OR SUPPORT FOR THIS APPLICATION OR ANY BREACH, LOSS, OR OTHER EVENT DUE TO USING THIS APPLICATION. IT IS FOR SECURITY TESTING AND EXAMPLE ONLY. 





