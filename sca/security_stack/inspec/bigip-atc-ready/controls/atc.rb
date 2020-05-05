# copyright: 2020, F5 Networks

title "Automation Toolchain Ready"

bigip_host = input('bigip_mgmt_ip')
bigip_mgmt_port = input('bigip_mgmt_port', value: 443)
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

# 
# Test that CFE is available and the correct version
#
control "Cloud Failover Extension Available" do
  impact 1.0
  title "BIGIP has CFE"
  # is the application services end point available?
    describe http("https://#{bigip_host}:#{bigip_mgmt_port}/mgmt/shared/cloud-failover/info",
              auth: {user: 'admin', pass: bigip_password},
              params: {format: 'html'},
              method: 'GET',
              ssl_verify: false) do
          its('status') { should cmp 200 }
          its('headers.Content-Type') { should match 'application/json' }
    end
    describe json(content: http("https://#{bigip_host}:#{bigip_mgmt_port}/mgmt/shared/cloud-failover/info",
              auth: {user: 'admin', pass: bigip_password},
              params: {format: 'html'},
              method: 'GET',
              ssl_verify: false).body) do
          its('version') { should eq '1.2.0' }
          its('release') { should eq '0' } # this should be replaced with a test using the json resource
    end
end

# 
# Test that TS is available and the correct version
#
control "Telemetry Streaming Available" do
  impact 1.0
  title "BIGIP has TS"
  # is the application services end point available?
    describe http("https://#{bigip_host}:#{bigip_mgmt_port}/mgmt/shared/telemetry/info",
              auth: {user: 'admin', pass: bigip_password},
              params: {format: 'html'},
              method: 'GET',
              ssl_verify: false) do
          its('status') { should cmp 200 }
          its('headers.Content-Type') { should match 'application/json' }
    end
    describe json(content: http("https://#{bigip_host}:#{bigip_mgmt_port}/mgmt/shared/telemetry/info",
              auth: {user: 'admin', pass: bigip_password},
              params: {format: 'html'},
              method: 'GET',
              ssl_verify: false).body) do
          its('version') { should eq '1.11.0' }
          its('release') { should eq '1' } # this should be replaced with a test using the json resource
    end
end