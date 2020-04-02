# Deployment of the Secure Cloud Architecture Demo
This directory contains the various Terraform modules to create the Secure Cloud Architecture (SCA) components:
- Core: deployed the required AWS base infrastructure
- Security Stack: deploys the Internet Ingress/Egress security stack and the various BIG-IPs 
- Application Stack: deploys the EC2 based application stack
- Container Stack: deploys the container based application stack

## Deploy
To deploy the full SCA stack you'll need to progress through the sub folders in the following order:
1. core
2. security_stack
3. application_stack
4. container_stack