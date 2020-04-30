# find an 18.04 ubuntu image because we want
# to use the newer YAML cloud-init
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# create appnodes_per_az number of application servers
# per each availability zone
# their names in the AWS portal will look like appnode-az1-2
resource "aws_instance" "appnode" { 
  for_each = {
    for n in range(var.appnodes_per_az * length(var.subnets.value)):
      "${keys(var.subnets.value)[n % length(var.subnets.value)]}-${n % var.appnodes_per_az}" => var.subnets.value[keys(var.subnets.value)[n % length(var.subnets.value)]]
  }
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  subnet_id               = each.value.application.application_region
  user_data               = file("${path.module}/cloudinit.yml")
  tags = {
    Name = "appnode-${each.key}"
  }
}
