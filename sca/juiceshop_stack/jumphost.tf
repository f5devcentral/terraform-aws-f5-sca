
resource "aws_instance" "jumphost" { 
  ami                     = data.aws_ami.ubuntu.id
  instance_type           = "t2.micro"
  key_name                = "f5uberdemo"
  subnet_id               = var.subnets.value.az1.application.application_region
  user_data               = file("${path.module}/cloudinit.yml")
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags                    = {
    Name = "jumphost"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpcs.value.application

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpcs.value.application
  tags = {
    Name = "application"
  }
}

resource "aws_eip" "lb" {
  instance = aws_instance.jumphost.id
  vpc      = true
}
