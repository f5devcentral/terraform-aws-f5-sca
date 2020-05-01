#!/bin/bash
tf_output_file='inspec/application-stack-ready/files/terraform.json'

# Save the Terraform data into a JSON file for InSpec to read
terraform output --json > $tf_output_file

# Run InSpec tests from the Jumphost
# assumes that the environment variable AWS_REGION is set
# that can be overriden by specifying the region on the command
# line e.g. inspec exec inspec/application-stack-ready -t aws://us-west-2
inspec exec inspec/application-stack-ready -t aws://