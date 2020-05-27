# JumpHost Stack

## Deployment Steps
### Obtain state from 0-core and security stack
```bash
terraform output -state=../core/terraform.tfstate --json > core.auto.tfvars.json
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

This module deploys a two Ubuntu 18.x Server jump hosts. These systems run an SSH and RDP service allowing remote access into the environment. It is critical that you do the following

1. Lock down the incoming Security Group to your public IPs noted in /CIDR format via the variable.
2. SSH in with your __predefined__ [AWS key](https://docs.aws.amazon.com/cli/latest/userguide/cli-services-ec2-keypairs.html) to setup a User/Pass for RDP access.  Your key must be in the same region that you are deploying to. 
3. It is recomended that you run an update once deployed to apply the latest security patches.

### Dependenices

This stack depends on the core stack being deployed first. No other stacks are dependent on it. 