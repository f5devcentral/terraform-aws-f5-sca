#!/bin/bash
tf_output_file='inspec/security-stack-ready/files/terraform.json'

# Save the Terraform data into a JSON file for InSpec to read
terraform output --json > $tf_output_file

# internal management interfaces - uncommented when jumphost is ready
bigips=$(jq '.bigip_mgmt_dns.value[][]' $tf_output_file -r)
bigip_mgmt_port=443
bigip_instance_ids=$(terraform show --json | jq '.values.root_module.child_modules[].resources[] | select(.address=="aws_instance.f5_bigip") | .values.id' -r)

for bigip_instance_id in $bigip_instance_ids
do
    echo $bigip_instance_id
    inspec exec inspec/security-stack-ready --input instance_id=$bigip_instance_id -t aws:// || break
done || exit 1

# get the BIG-IP password
secrets_manager_name=$(jq '.secrets_manager_name.value' core.auto.tfvars.json)
secrets_manager_id=$(terraform show -json | jq '.values.root_module.child_modules[].resources[] | select(.address=="data.aws_secretsmanager_secret.password") | .values.id ' -r | head -n 1)
bigip_password=$(aws secretsmanager get-secret-value --secret-id "$secrets_manager_id" | jq '.SecretString' -r)
for bigip in $bigips
do
    echo $bigip
    inspec exec inspec/security-stack-ready --input bigip_mgmt_ip=$bigip bigip_password=$bigip_password || break
done || exit 1