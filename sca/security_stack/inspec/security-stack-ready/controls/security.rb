# copyright: 2020, F5 Networks

title "Security Stack"

# load data from Terraform output
# created by terraform output --json > inspec/bigip-ready/files/terraform.json
# content = inspec.profile.file("terraform.json")
# params = JSON.parse(content)

# begin
#     BIGIP_MGMT_IPS    = params['bigip_mgmt_ips'][*]['value']
#     BIGIP_MGMT_DNS    = params['bigip_mgmt_dns']['value']
#     BIGIP_MGMT_PORT   = params['bigip_mgmt_port']['value']
#     MGMT_ADDRESSES    = params['mgmt_addresses']['value']
#     PUBLIC_ADDRESSES  = params['public_addresses']['value']
#     PRIVATE_ADDRESSES = params['private_addresses']['value']
#     PUBLIC_NIC_IDS    = params['public_nic_ids']['value']
# rescue
#     BIGIP_MGMT_IPS    = []
#     BIGIP_MGMT_DNS    = []
#     BIGIP_MGMT_PORT   = []
#     MGMT_ADDRESSES    = []
#     PUBLIC_ADDRESSES  = []
#     PRIVATE_ADDRESSES = []
#     PUBLIC_NIC_IDS    = []
# end

bigip_host = input('bigip_mgmt_ip')
bigip_mgmt_port = input('bigip_mgmt_port')
bigip_password = input('bigip_password')

# 
# Test that DO is available and the correct version
#
control "Declarative Onboarding Available" do
  impact 1.0
  title "BIGIP has DO"
  # is the declarative onboarding end point available?
  describe http("https://#{bigip_host}:#{bigip_mgmt_port}/mgmt/shared/declarative-onboarding/info",
              auth: {user: 'admin', pass: bigip_password},
              params: {format: 'html'},
              method: 'GET',
              ssl_verify: false) do
          its('status') { should cmp 200 }
          its('headers.Content-Type') { should match 'application/json' }
  end
  describe json(content: http("https://#{bigip_host}:#{bigip_mgmt_port}/mgmt/shared/declarative-onboarding/info",
              auth: {user: 'admin', pass: bigip_password},
              params: {format: 'html'},
              method: 'GET',
              ssl_verify: false).body) do
          its([0,'version']) { should eq '1.12.0' }
          its([0,'release']) { should eq '1' } # this should be replaced with a test using the json resource
  end
end 

# 
# Test that AS3 is available and the correct version
#
control "Application Service Extension Available" do
  impact 1.0
  title "BIGIP has AS3"
  # is the application services end point available?
    describe http("https://#{bigip_host}:#{bigip_mgmt_port}/mgmt/shared/appsvcs/info",
              auth: {user: 'admin', pass: bigip_password},
              params: {format: 'html'},
              method: 'GET',
              ssl_verify: false) do
          its('status') { should cmp 200 }
          its('headers.Content-Type') { should match 'application/json' }
    end
    describe json(content: http("https://#{bigip_host}:#{bigip_mgmt_port}/mgmt/shared/appsvcs/info",
              auth: {user: 'admin', pass: bigip_password},
              params: {format: 'html'},
              method: 'GET',
              ssl_verify: false).body) do
          its('version') { should eq '3.13.2' }
          its('release') { should eq '1' } # this should be replaced with a test using the json resource
    end
end
