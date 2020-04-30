# copyright: 2020, F5 Networks

title "Application Stack AWS Configuration"

# load data from Terraform output
# created by terraform output --json > inspec/application-stack-ready/files/terraform.json
content = inspec.profile.file("terraform.json")
params = JSON.parse(content)
begin
    JUICESHOP_AWS_NAME = params['juiceshop_aws_names']['value']
rescue 
    JUICESHOP_AWS_NAME = []
end

JUICESHOP_AWS_NAME.each do |juiceshop_node|
    describe aws_ec2_instance(name: juiceshop_node) do
        it { should exist }
        it { should be_running }
    end
end

