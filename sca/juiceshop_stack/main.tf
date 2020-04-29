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

resource "aws_instance" "appnode" { 
  for_each = {
    for n in range(var.appnodes_per_az * length(var.subnets.value)):
      "${keys(var.subnets.value)[n % length(var.subnets.value)]}-${n % var.appnodes_per_az}" => var.subnets.value[keys(var.subnets.value)[n % length(var.subnets.value)]]
  }
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  subnet_id               = each.value.application.application_region
  user_data               = file("${path.module}/cloudinit.yml")
  #vpc_security_group_ids = [var.security_groups.value.private]
  tags = {
    Name = "appnode-${each.key}"
  }
}
