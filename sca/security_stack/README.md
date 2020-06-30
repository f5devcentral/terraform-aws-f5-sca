# Security Stack Deployment
This stack deploys the Security stack that protects the various application stacks.  
For demo purposes it will deploy three pairs of F5 BIG-IP appliances:
 - External BIG-IPs at the Internet Edge of the Security Stack
 - IPS BIG-IPs for network inspection and intrusion prevention services
 - Internal BIG-IPs at the Inside Edge of the Security Stach for application security

## Configuration
Create *terraform.tfvars* with the following:
```shell
ec2_key_name="mypreviouslycreatedec2keypairname"
``` 

## Deployment Steps
### Obtain state from 0-core
```bash
terraform output -state=../core/terraform.tfstate --json > core.auto.tfvars.json
```
### Initialize Terraform
```bash
terraform init
```
### Validate and Apply
```bash
terraform validate && terraform apply && terraform apply
```
Note: the second ```terraform apply``` addresses a transient issue in which the outputs are not properly populated.