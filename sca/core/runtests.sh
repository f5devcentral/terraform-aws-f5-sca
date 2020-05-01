#!/bin/bash
tf_output_file='inspec/core-ready/files/terraform.json'

vpc_ids="$(terraform show -json | jq '.values.root_module.child_modules[].resources[] | select(.type=="aws_vpc") | .values.id' -r | paste -sd "," -)"
security_vpc_id=$(terraform show -json | jq '.values.root_module.child_modules[].resources[] | select(.type=="aws_vpc" and .name=="security-vpc") | .values.id' -r)
security_subnets=$(terraform show -json | jq '.values.root_module.child_modules[].resources[] | select(.type=="aws_subnet" and .values.vpc_id==env.security_vpc_id)')
security_subnet_ids="$(echo $security_subnets | jq '.values.id' -r | paste -sd "," -)"
security_subnet_az1=$(echo $security_subnets | jq 'select(.name | contains("az-1")) | .values.availability_zone | split("-") | last'| head -1)
security_subnet_az2=$(echo $security_subnets | jq 'select(.name | contains("az-2")) | .values.availability_zone | split("-") | last'| head -1)

application_vpc_id=$(terraform show -json | jq '.values.root_module.child_modules[].resources[] | select(.type=="aws_vpc" and .name=="application-test") | .values.id' -r)
application_subnets=$(terraform show -json | jq '.values.root_module.child_modules[].resources[] | select(.type=="aws_subnet" and .values.vpc_id==env.application_vpc_id)')
application_subnet_ids="$(echo $application_subnets | jq '.values.id' -r | paste -sd "," -)"
application_subnet_az1=$(echo $application_subnets | jq 'select(.name | contains("az-1")) | .values.availability_zone | split("-") | last'| head -1)
application_subnet_az2=$(echo $application_subnets | jq 'select(.name | contains("az-2")) | .values.availability_zone | split("-") | last'| head -1)

container_vpc_id=$(terraform show -json | jq '.values.root_module.child_modules[].resources[] | select(.type=="aws_vpc" and .name=="container-test") | .values.id' -r)
container_subnets=$(terraform show -json | jq '.values.root_module.child_modules[].resources[] | select(.type=="aws_subnet" and .values.vpc_id==env.container_vpc_id)')
container_subnet_ids="$(echo $container_subnets | jq '.values.id' -r | paste -sd "," -)"
container_subnet_az1=$(echo $container_subnets | jq 'select(.name | contains("az-1")) | .values.availability_zone | split("-") | last'| head -1)
container_subnet_az2=$(echo $container_subnets | jq 'select(.name | contains("az-2")) | .values.availability_zone | split("-") | last'| head -1)

subnets_az1="$security_subnet_az1,$application_subnet_az1,$container_subnet_az1"

# Run InSpec tests from the Jumphost
inspec exec inspec/aws-vpc --input vpc_ids=$vpc_ids security_vpc_id=$security_vpc_id \
security_subnet_ids=$security_subnet_ids application_vpc_id=$application_vpc_id \
application_subnet_ids=$application_subnet_ids container_vpc_id=$container_vpc_id \
container_subnet_ids=$container_subnet_ids subnets_az1=$subnets_az1 -t aws://