# copyright: 2020, F5 Networks

title "SCA Core"

# load data from Terraform output
# created by terraform output --json > inspec/bigip-ready/files/terraform.json
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

begin
    SECURITY_GROUPS  = params['security_groups']['value']
    VPCS             = params['vpcs']['value']
    SUBNETS          = params['subnets']['value']
    ROUTE_TABLES     = params['route_tables']['value']
    TRANSIT_GATEWAYS = params['transit_gateways']['value']
rescue
    SECURITY_GROUPS  = []
    VPCS             = []
    SUBNETS          = []
    ROUTE_TABLES     = []
    TRANSIT_GATEWAYS = []
end

#
# TODO: what tests validate that the sca core is ready?
#
