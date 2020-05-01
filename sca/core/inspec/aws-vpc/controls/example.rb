# copyright: 2018, The Authors

title "Sample Section"

vpc_ids = input('vpc_ids').split(",")
security_subnet_ids = input('security_subnet_ids').split(",")
application_subnet_ids = input('application_subnet_ids').split(",")
container_subnet_ids = input('container_subnet_ids').split(",")
subnets_az1 = input('subnets_az1').split(",")

control "aws-single-vpc-exists-check" do 
  impact 1.0                                                                
  title "Check to see if SCA VPC exists."                                
  vpc_ids.each do |vpc_id|
    describe aws_vpc(vpc_id) do 
      it { should exist }
      it { should be_available }
    end
  end
end

control "check-security-subnets" do
  impact 1.0
  title "Check that the required subnets were created."
  describe aws_subnets.where( vpc_id: input('security_vpc_id')) do
    its('states') { should_not include 'pending' }
    security_subnet_ids.each do |security_subnet_id| 
      its('subnet_ids') { should include security_subnet_id }
    end
  end
end

control "check-appliation-subnets" do
  impact 1.0
  title "Check that the required subnets were created."
  describe aws_subnets.where( vpc_id: input('application_vpc_id')) do
    its('states') { should_not include 'pending' }
    application_subnet_ids.each do |application_subnet_id| 
      its('subnet_ids') { should include application_subnet_id }
    end
  end
end

control "check-container-subnets" do
  impact 1.0
  title "Check that the required subnets were created."
  describe aws_subnets.where( vpc_id: input('container_vpc_id')) do
    its('states') { should_not include 'pending' }
    container_subnet_ids.each do |container_subnet_id| 
      its('subnet_ids') { should include container_subnet_id }
    end
  end
end

# control "check-subnets-azs" do
#   impact 1.0
#   title "Check that the subnets are in the right availability zones."
#   subnets_az1.each do | az_subnet1
#     (az_subnet1) { should eq "1a"}
# end