# Configuration Stack Deployment
This stack deploys the configuration to the infrastructure from the Security stack  stacks.  
It will use the F5 Automation Toolchain for programmatic, declarative deployment of this configuration, using:
- Declarative Onboarding (DO) for device-level configuration (selfIP's, DNS servers, cluster config, etc)
- Cloud Failover Extension (CFE) for configuration of HA failover

## Deployment Steps
### Obtain state from 0-core
```bash
terraform output -state=../core/terraform.tfstate --json > core.auto.tfvars.json
```
### Obtain state from 1-security stack
```bash
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

### Known Issues
- https://github.com/F5Networks/terraform-provider-bigip/issues/61
- https://github.com/F5Networks/f5-declarative-onboarding/issues/129

