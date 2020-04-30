#!/bin/bash
tf_output_file='inspec/security-stack-ready/files/terraform.json'

# Save the Terraform data into a JSON file for InSpec to read
terraform output --json > $tf_output_file

# TODO: uncomment once a jumphost is created
# Set the jumphost IP address
#jumphost=`cat $tf_output_file| jq '.jumphost_ip.value[0]' -r`

# Run InSpec tests from the Jumphost
#inspec exec inspec/security-stack-ready -t ssh://azureuser@$jumphost -i tftest
bigips=$(jq '.mgmt_addresses.value[][]' $tf_output_file)
bigip_mgmt_port=443

# get the BIG-IP password
secrets_manager_name=$(jq '.secrets_manager_name.value' core.auto.tfvars.json)
secrets_manager_id=$(terraform show -json | jq '.values.root_module.child_modules[].resources[] | select(.address=="data.aws_secretsmanager_secret.password") | .values.id ' -r | head -n 1)
bigip_password=$(aws secretsmanager get-secret-value --secret-id "$secrets_manager_id" | jq '.SecretString' -r)
for bigip in $bigips
do
    echo $bigip
    inspec exec inspec/security-stack-ready --input bigip_mgmt_ip=$bigip bigip_password=$bigip_password
done