# copyright: 2020, F5 Networks

title "Security Stack"

# load data from Terraform output
# created by terraform output --json > inspec/bigip-ready/files/terraform.json
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)

begin
    BIGIP_MGMT_IPS    = params['bigip_mgmt_ips']['value']
    BIGIP_MGMT_DNS    = params['bigip_mgmt_dns']['value']
    BIGIP_MGMT_PORT   = params['bigip_mgmt_port']['value']
    MGMT_ADDRESSES    = params['mgmt_addresses']['value']
    PUBLIC_ADDRESSES  = params['public_addresses']['value']
    PRIVATE_ADDRESSES = params['private_addresses']['value']
    PUBLIC_NIC_IDS    = params['public_nic_ids']['value']
rescue
    BIGIP_MGMT_IPS    = []
    BIGIP_MGMT_DNS    = []
    BIGIP_MGMT_PORT   = []
    MGMT_ADDRESSES    = []
    PUBLIC_ADDRESSES  = []
    PRIVATE_ADDRESSES = []
    PUBLIC_NIC_IDS    = []
end

#
# TODO: what tests validate that the security stack is ready?
#
