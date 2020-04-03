#!/bin/bash
tf_output_file='inspec/sca-ready/files/terraform.json'

# Save the Terraform data into a JSON file for InSpec to read
terraform output --json > $tf_output_file

# Set the jumphost IP address
jumphost=`cat $tf_output_file| jq '.jumphost_ip.value[0]' -r`

# Run InSpec tests from the Jumphost
inspec exec inspec/sca-ready -t ssh://azureuser@$jumphost -i tftest