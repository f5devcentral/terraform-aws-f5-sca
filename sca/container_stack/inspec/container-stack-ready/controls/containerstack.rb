# copyright: 2020, F5 Networks

title "Container Stack"

# load data from Terraform output
# created by terraform output --json > inspec/bigip-ready/files/terraform.json
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)


#
# TODO: what tests validate that the container stack is ready?
#
