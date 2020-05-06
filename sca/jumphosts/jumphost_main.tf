/* ## F5 Networks Secure Cloud Migration and Securty Zone Template for AWS ####################################################################################################################################################################################
Version 1.4
March 2020


This Template is provided as is and without warranty or support.  It is intended for demonstration or reference purposes. While all attempts are made to ensure it functions as desired it is not a supported by F5 Networks.  This template can be used 
to quickly deploy a Security VPC - aka DMZ, in-front of the your application VPC(S).  Additional VPCs can be added to the template by adding CIDR variables, VPC resource blocks, VPC specific route tables 
and TransitGateway edits. Limits to VPCs that can be added are =to the limits of transit gateway.

It is built to run in a region with three zones to use and will place services in 1a and 1c.  Modifications to other zones can be done.

F5 Application Services will be deployed into the security VPC but if one wished they could also be deployed inside of the Application VPCs. 

*/
###############################################################################################################################################################################################################################################################

resource "aws_security_group" "allow_jump_hosts" {
  name        = "allow_incoming_jump_host"
  description = "Allow Jumphost inbound traffic"
  vpc_id      = var.vpcs.value.security

  ingress {
    # TLS (change to whatever ports you need)
    from_port   = 22
    to_port     = 22
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = var.my_public_ip
  }
  ingress {
    # RDP (change to whatever ports you need)
    from_port   = 3389
    to_port     = 3389
    protocol    = "-1"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = var.my_public_ip
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Create a new instance of the latest Ubuntu 14.04 on an
# t2.micro node with an AWS Tag naming it "HelloWorld"

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "Jumphost_AZ1" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name = var.jump_ssh_key
  associate_public_ip_address = true
  subnet_id = var.subnets.value.az1.security.mgmt
  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt —yes —force-yes install xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils
              apt —yes —force-yes install xrdp
              apt —yes —force-yes install awscli
              apt —yes install python
              snap install postman
              EOF


  tags = {
    Name = "var.project.Jumphost"
  }
}

resource "aws_instance" "Jumphost_AZ2" {
  ami           = "${data.aws_ami.ubuntu.id}"
  instance_type = "t2.micro"
  key_name = var.jump_ssh_key
  associate_public_ip_address = true
  subnet_id = var.subnets.value.az2.security.mgmt
  user_data = <<-EOF
              #!/bin/bash
              apt update
              apt —yes —force-yes install xfce4 xfce4-goodies xorg dbus-x11 x11-xserver-utils
              apt —yes —force-yes install xrdp
              apt —yes —force-yes install awscli
              apt —yes install python
              snap install postman
              EOF


  tags = {
    Name = "var.project.Jumphost"
  }
}