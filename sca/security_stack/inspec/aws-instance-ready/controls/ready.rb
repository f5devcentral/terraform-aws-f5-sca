# copyright: 2020, F5 Networks

title "AWS Instance Ready"

control "Running in AWS" do
    impact 1.0
    title "AWS shows BIG-IP EC2 instance is running"
    describe aws_ec2_instance(input('instance_id')) do
        it { should exist }
        it { should be_running }
    end
end